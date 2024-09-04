class Corteclass {
  //identificacao do cliente
  final String id;
  final String clienteNome;
  final String urlImagePerfilfoto;
  //identificacao da barbearia
  final String barbeariaId;
  
  //identificacao do profissional
  final String ProfissionalSelecionado;
  final String urlImageProfissionalFoto;
  final String profissionalId;
  final double porcentagemDoProfissional;

  //verificacao de pagamento e procedimento
  final double valorCorte;
  final bool preencher2horarios;
  final bool JaCortou;
  final bool pagoucomcupom;
  final bool pagouPeloApp;
  final int pontosGanhos;

  //informacoes do dia e horario
  final List<String>horariosExtras;
  final String idDoServicoSelecionado;
  final String nomeServicoSelecionado;
  final String horarioSelecionado;
  final String diaSelecionado;
  final String MesSelecionado;
  final String anoSelecionado;
  final DateTime dataSelecionadaDateTime;
  final DateTime momentoDoAgendamento;
  Corteclass({
    required this.porcentagemDoProfissional,
    required this.horariosExtras,
    required this.idDoServicoSelecionado,
    required this.nomeServicoSelecionado,
    required this.JaCortou,
    required this.MesSelecionado,
    required this.ProfissionalSelecionado,
    required this.anoSelecionado,
    required this.barbeariaId,
    required this.clienteNome,
    required this.dataSelecionadaDateTime,
    required this.diaSelecionado,
    required this.horarioSelecionado,
    required this.id,
    required this.momentoDoAgendamento,
    required this.pagouPeloApp,
    required this.pagoucomcupom,
    required this.pontosGanhos,
    required this.preencher2horarios,
    required this.profissionalId,
    required this.urlImagePerfilfoto,
    required this.urlImageProfissionalFoto,
    required this.valorCorte,
  });
}
