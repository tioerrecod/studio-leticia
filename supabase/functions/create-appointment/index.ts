import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    const supabaseAnonKey = Deno.env.get('SUPABASE_ANON_KEY') ?? ''

    const authHeader = req.headers.get('Authorization')!
    const userClient = createClient(supabaseUrl, supabaseAnonKey, {
      auth: { persistSession: false },
      global: { headers: { Authorization: authHeader } }
    })

    const { data: { user }, error: authError } = await userClient.auth.getUser()
    if (authError || !user) {
      return new Response(
        JSON.stringify({ error: 'Não autorizado' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const { serviceId, professionalId, dateTime, notes } = await req.json()

    if (!serviceId || !professionalId || !dateTime) {
      return new Response(
        JSON.stringify({ error: 'serviceId, professionalId e dateTime são obrigatórios' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const admin = createClient(supabaseUrl, supabaseServiceKey, {
      auth: { persistSession: false }
    })

    const { data: service, error: serviceError } = await admin
      .from('services')
      .select('*')
      .eq('id', serviceId)
      .single()

    if (serviceError || !service) {
      return new Response(
        JSON.stringify({ error: 'Serviço não encontrado' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const appointmentDate = new Date(dateTime)
    const { data: conflict } = await admin
      .from('appointments')
      .select('id')
      .eq('professional_id', professionalId)
      .eq('status', 'scheduled')
      .gte('date_time', new Date(appointmentDate.getTime() - 3600000).toISOString())
      .lte('date_time', new Date(appointmentDate.getTime() + 3600000).toISOString())
      .maybeSingle()

    if (conflict) {
      return new Response(
        JSON.stringify({ error: 'Horário já reservado para este profissional' }),
        { status: 409, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const { data: appointment, error: insertError } = await admin
      .from('appointments')
      .insert({
        customer_id: user.id,
        service_id: serviceId,
        professional_id: professionalId,
        date_time: appointmentDate.toISOString(),
        status: 'scheduled',
        notes: notes || null,
      })
      .select('*')
      .single()

    if (insertError) {
      return new Response(
        JSON.stringify({ error: 'Erro ao criar agendamento' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    await admin.from('notifications').insert({
      user_id: user.id,
      type: 'appointment_created',
      title: 'Agendamento confirmado',
      body: `${service.name} confirmado para ${appointmentDate.toLocaleDateString('pt-BR')}`,
      data: { appointment_id: appointment.id },
    })

    return new Response(
      JSON.stringify({ data: appointment }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
