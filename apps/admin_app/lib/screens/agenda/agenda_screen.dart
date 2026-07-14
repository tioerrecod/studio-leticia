import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SLColors.background,
      appBar: AppBar(
        title: Text(
          'Agenda',
          style: SLTypography.h3.copyWith(
            color: SLColors.carbon,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: SLSpacing.md),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              SLSpacing.xl, 0, SLSpacing.xl, SLSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Segunda, 13 de julho',
                  style: SLTypography.h2.copyWith(
                    color: SLColors.carbon,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: SLSpacing.xs),
                Text(
                  '6 agendamentos hoje',
                  style: SLTypography.caption.copyWith(
                    color: SLColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SLAppointmentCard(
            time: '09:00',
            customerName: 'Rafaela',
            serviceName: 'Hidrata\u00e7\u00e3o Premium',
            rating: '5.0',
            iaSuggestion: 'Confirmado',
            onTap: () {},
          ),
          SLAppointmentCard(
            time: '10:30',
            customerName: 'Mariana',
            serviceName: 'Corte Personalizado',
            iaSuggestion: 'Aguardando confirma\u00e7\u00e3o',
            onTap: () {},
          ),
          SLAppointmentCard(
            time: '11:00',
            customerName: 'Camila',
            serviceName: 'Escova Modeladora',
            onTap: () {},
          ),
          SLAppointmentCard(
            time: '14:00',
            customerName: 'Ana Beatriz',
            serviceName: 'Colora\u00e7\u00e3o + Corte',
            rating: '4.5',
            onTap: () {},
          ),
          SLAppointmentCard(
            time: '15:30',
            customerName: 'Juliana',
            serviceName: 'Spa Capilar Experi\u00eancia',
            iaSuggestion: 'Aniversariante do m\u00eas',
            onTap: () {},
          ),
          SLAppointmentCard(
            time: '17:00',
            customerName: 'Patr\u00edcia',
            serviceName: 'Corte Personalizado',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
