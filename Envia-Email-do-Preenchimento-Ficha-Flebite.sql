create or replace PROCEDURE DBAMV.PRC_ENVIA_EMAIL_NOTIFICACAO_FLEBITE( pATENDIMENTO NUMBER,
                                                                        pUSUARIO VARCHAR2
                                                                      ) AS
TEXTO CLOB;
TEXTO2 CLOB;
CONT NUMBER(2);
vNOMEPACIENTE VARCHAR2(200);
vIDADEPACIENTE VARCHAR2(20);
vDATANASCIMENTO VARCHAR2(20);
vDATADOC VARCHAR2(30);

vATENDIMENTO NUMBER;
vUSUARIO VARCHAR2(100);

/************************************************************************************
 *  OWNER: DBAMV                                                                    *
 ************************************************************************************
 *  OBJETO: DBAMVPRC_ENVIA_EMAIL_NOTIFICACAO_FLEBITE                                *
 ************************************************************************************
 *  OBJETIVO DA PROCEDURE:                                                          *
 *    - Este objeto tem por objetivo disparar email mediante o preenchimento   do   *
 *      documento 787.                                                              *
 *|--------------------------------------------------------------------------------|*
 *| Data Desen. | Proprietario            | Dev.              | Versao | Alteracao |*
 *|------------+-------------------------+------------------+--------+-------------|*
 *| 26/03/2026  | Desenv                 | Gabriel            | 1.0    |           |*
 *|--------------------------------------------------------------------------------|*
 ************************************************************************************/


BEGIN
      CONT := 0;
      vATENDIMENTO := NVL(pATENDIMENTO,0);
      vUSUARIO := NVL(pUSUARIO,'');

     BEGIN   
        SELECT P.NM_PACIENTE, 
               FN_IDADE(P.DT_NASCIMENTO, 'x X'),
               TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'),
               FNC.HISTORICO(P.CD_ATENDIMENTO,'DT_NASCIMENTO')
          INTO vNOMEPACIENTE, 
               vIDADEPACIENTE,
               vDATADOC,
               vDATANASCIMENTO
          FROM ATENDIMENTOS A
    INNER JOIN CLIENTES P                   ON P.CD_CLIENTE  = A.CD_CLIENTE
    INNER JOIN DOCUMENTO P                  ON P.CD_ATENDIMENTO = A.CD_ATENDIMENTO
    INNER JOIN EDITOR_CLINICO PEC           ON PEC.CD_DOCUMENTO_CLINICO = P.CD_DOCUMENTO_CLINICO
         WHERE 1 = 1
           AND P.CD_ATENDIMENTO = vATENDIMENTO         
           AND PEC.CD_DOCUMENTO = 787 --Notificaçao Flebite
           --AND PDC.TP_STATUS IN ('ABERTO')
         ORDER BY TO_CHAR(PDC.DH_FECHAMENTO,'DD/MM/YYYY HH24:MI:SS') DESC
         FETCH NEXT 1 ROWS ONLY;
     EXCEPTION WHEN NO_DATA_FOUND THEN             
                     vNOMEPACIENTE := '';
                     vIDADEPACIENTE :='';
                     vDATANASCIMENTO := '';
                     vDATADOC := '';
    END;

        TEXTO2 := 'Notificação Flebite';

        TEXTO := '<html lang="pt-br">
                <head>
                  <meta charset="iso-8859-1"/>
                </head>
                    <body>
                        <h2>'||vNOMEPACIENTE||'</h2>
                        <p><b>Data de Nascimento: </b>'||vDATANASCIMENTO||' - '||vIDADEPACIENTE||'</p>
                        <p><b>Data do documento: </b>'||vDATADOC||'</p>
                        <p><b>Atendimento: </b>'||vATENDIMENTO||'</p>
                        <p><b>Preenchido por: </b>'||vUSUARIO||'</p>  
                    </body>
                </html>';  

    DECLARE
        TYPE CARACTERES IS TABLE OF VARCHAR2(50);
        CARACTERES_ISO CARACTERES;
        CARACTERES_UTF CARACTERES;
    BEGIN   
        CARACTERES_ISO := CARACTERES('&Aacute;','&Eacute;','&Iacute;','&Oacute;','&Uacute;','&aacute;','&eacute;','&iacute;','&oacute;','&uacute;','&Acirc;','&Ecirc;','&Ocirc;',
                                        '&acirc;','&ecirc;','&ocirc;','&Agrave;','&agrave;','&Uuml;','&uuml;','&Ccedil;','&ccedil;','&Atilde;','&Otilde;','&atilde;','&otilde;',
                                        '&Ntilde;','&ntilde;');
        CARACTERES_UTF := CARACTERES('Á','É','Í','Ó','Ú','á','é','í','ó','ú','Â','Ê','Ô','â','ê','ô','À','à','Ü','ü','Ç','ç','Ã','Õ','ã','õ','Ñ','ñ');         

        FOR ITEM IN CARACTERES_UTF.FIRST..CARACTERES_UTF.LAST
        LOOP
            TEXTO := REPLACE(TEXTO, CARACTERES_UTF(ITEM), CARACTERES_ISO(ITEM));
            DBMS_OUTPUT.PUT_LINE(TEXTO2);
        END LOOP;
    END;

    PRC_GRAVAEMAIL(
                            'text/html',
                            'Documento 787',
                            'Informática',
                            'sistemasdesen123456@gmail.com.br',
                            'Notificação Flebite',
                            'teste.desenvolvimento@gmail.com'
                             TEXTO2,
                             TEXTO
      );

END;

GRANT EXECUTE ON DBAMV.PRC_ENVIA_EMAIL_NOTIFICACAO_FLEBITE TO ACESSOPRD;
