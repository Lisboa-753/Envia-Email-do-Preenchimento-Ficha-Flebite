# Procedure de Envio de E-mail - Preenchimento de Notificações de Flebites.
Este projeto contém uma procedure (função no banco de dados Oracle) que envia um e-mail com informações referentes ao preenchimento da ficha de notificação de flebite.

## Objetivo

O objetivo principal desta procedure é enviar ** Notificar as coordenadores dos postos do hospital referente ao preenchimente da notificação de flebite ** com dados como:

- Atendimento do paciente a qual foi preenchido a notificação,
- Idade e data de nascimento do paciente,
- Nome do paciente,
- Data do preenchimento.


Essas informações são mostradas em um modelo de e-mail em HTML, pronto para ser enviado.

## Como funciona

A procedure do banco de dados é chamada toda vez que é preenchido uma ficha, onde é montado o email com as informações mencionada acima.
Tudo isso é feito de forma automática, sem precisar escrever o e-mail manualmente.

## Tecnologias utilizadas

- Oracle PL/SQL
- Banco de dados relacional
- HTML para formatar o e-mail

## Uso

Esta procedure pode ser útil para sistemas que:

- Setores que fazem o controle do cuidado do paciente
- Precisam enviar relatórios por e-mail
- Querem automatizar esse processo e ganhar tempo

---
