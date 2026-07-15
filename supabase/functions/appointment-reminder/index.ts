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

    const supabase = createClient(supabaseUrl, supabaseServiceKey, {
      auth: { persistSession: false }
    })

    const now = new Date()
    const in24Hours = new Date(now.getTime() + 24 * 60 * 60 * 1000)
    const in25Hours = new Date(now.getTime() + 25 * 60 * 60 * 1000)

    const { data: appointments, error } = await supabase
      .from('appointments')
      .select(`
        id,
        date_time,
        customer_id,
        service:services(name, duration),
        professional:professionals(name)
      `)
      .eq('status', 'scheduled')
      .gte('date_time', in24Hours.toISOString())
      .lte('date_time', in25Hours.toISOString())

    if (error) {
      throw error
    }

    if (!appointments || appointments.length === 0) {
      return new Response(
        JSON.stringify({ message: 'Nenhum agendamento para lembrar', count: 0 }),
        { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    let sent = 0
    for (const appointment of appointments) {
      const serviceName = (appointment.service as any)?.name || 'serviço'
      const professionalName = (appointment.professional as any)?.name || 'profissional'
      const appointmentTime = new Date(appointment.date_time).toLocaleTimeString('pt-BR', {
        hour: '2-digit',
        minute: '2-digit'
      })

      const { error: notifError } = await supabase
        .from('notifications')
        .insert({
          user_id: appointment.customer_id,
          type: 'appointment_reminder',
          title: 'Lembrete de agendamento',
          body: `Amanhã às ${appointmentTime} você tem ${serviceName} com ${professionalName}. Não esqueça!`,
          data: { appointment_id: appointment.id },
          read: false,
          created_at: now.toISOString(),
        })

      if (!notifError) {
        sent++
      }
    }

    return new Response(
      JSON.stringify({ message: `${sent} lembretes enviados`, count: sent }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
