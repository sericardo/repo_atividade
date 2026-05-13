CREATE OR REPLACE PACKAGE        APATQP11 IS

/* Procedure Principal - ENVIO DO RESULTADO DO PROCESSO  */

PROCEDURE APATQP11_000
(P_NUMAUTO  IN  VARCHAR2
 ,P_NUMPROC IN VARCHAR2
,P_DATA_JULG IN VARCHAR2
,P_COD_RESULTADO IN VARCHAR2
,P_JUSTIFICATIVA IN VARCHAR2
 ,P_TIPOSERV IN VARCHAR2
,p_cod_retorno out number
,P_MENSAGEM OUT VARCHAR2
 );

-- resultado defesa ou sol advertencia TESTE 123456

PROCEDURE APATQP11_100
(P_COD_GRUP_ATDR IN T5560_AIIP_CONSIST.COD_GRUP_ATDR%TYPE
,P_COD_SER_AIIP  IN T5560_AIIP_CONSIST.COD_SER_AIIP%TYPE
,P_COD_NRO_AIIP IN  T5560_AIIP_CONSIST.COD_NRO_AIIP%TYPE
,P_NUMPROC IN VARCHAR2
,P_DT_JLGM_DEFS_PRV IN  T5738_DEFES_PREVIA.DT_JLGM_DEFS_PRV%TYPE
,P_COD_RSLT_DEFS_PRV IN T5738_DEFES_PREVIA.COD_RSLT_DEFS_PRV%TYPE
,P_COD_MTVO_CANC IN T5738_DEFES_PREVIA.COD_MTVO_CANC%TYPE
 ,P_TIPOSERV IN VARCHAR2
,P_ANO_DEFS_PRV IN T5738_DEFES_PREVIA.ANO_DEFS_PRV%TYPE
,P_COD_NRO_DEFS_PRV IN T5738_DEFES_PREVIA.COD_NRO_DEFS_PRV%TYPE
,p_cod_retorno out number
,P_MENSAGEM OUT VARCHAR2
 );

-- OBTER PROCESSO DE DEFESA OU SOL. ADVERTENCIA

PROCEDURE APATQP11_110
 (P_COD_GRUP_ATDR IN T5559_AIIP_OUTROS.COD_GRUP_ATDR%TYPE
 ,P_COD_SER_AIIP IN T5559_AIIP_OUTROS.COD_SER_AIIP%TYPE
 ,P_COD_NRO_AIIP IN T5559_AIIP_OUTROS.COD_NRO_AIIP%TYPE
 ,P_COD_TIP_DOC_AUTC IN  T5738_DEFES_PREVIA.COD_TIP_DOC_AUTC%TYPE
 ,P_ANO OUT T5738_DEFES_PREVIA.ANO_DEFS_PRV%TYPE
 ,P_NRO OUT T5738_DEFES_PREVIA.COD_NRO_DEFS_PRV%TYPE
 ,P_EXISTE OUT VARCHAR2
 ,P_SITU OUT T5738_DEFES_PREVIA.COD_SITU_DEFS_PRV%TYPE
 ,P_RES OUT T5738_DEFES_PREVIA.COD_RSLT_DEFS_PRV%TYPE
 );

-- resultado jari ou cetran

PROCEDURE APATQP11_300
(P_COD_GRUP_ATDR IN T5560_AIIP_CONSIST.COD_GRUP_ATDR%TYPE
,P_COD_SER_AIIP  IN T5560_AIIP_CONSIST.COD_SER_AIIP%TYPE
,P_COD_NRO_AIIP IN  T5560_AIIP_CONSIST.COD_NRO_AIIP%TYPE
,P_NUMPROC IN VARCHAR2
,P_DT_RSLT_REC IN  T5591_RECURSO_DSV.DT_RSLT_REC%TYPE
,P_COD_RSLT_REC_PENA IN T5591_RECURSO_DSV.COD_RSLT_REC_PENA%TYPE
,P_COD_MTVO_RJCO_ADMI   IN T5591_RECURSO_DSV.COD_MTVO_RJCO_ADMI%TYPE
,P_TIPOSERV IN VARCHAR2
,P_COD_ORG_JLGD IN  T5591_RECURSO_DSV.COD_ORG_JLGD%TYPE
,P_ANO_REC IN T5591_RECURSO_DSV.ANO_REC%TYPE
,P_COD_NRO_REC IN  T5591_RECURSO_DSV.COD_NRO_REC%TYPE
,p_cod_retorno out number
,P_MENSAGEM OUT VARCHAR2
 ) ;

-- seleciona descricao t5496 motivo rejeicao adm recurso multa - cod 6
PROCEDURE APATQP11_301
 (P_COD_MVTO_CANC IN T5496_MTV_CANC_MLT.COD_MTVO_CANC%TYPE
 ,P_TXT_MTVO_RJCO OUT T5496_MTV_CANC_MLT.TXT_MTVO_RJCO%TYPE );



END APATQP11;

/


CREATE OR REPLACE PACKAGE BODY    APATQP11 IS


/* Procedure Principal - ENVIO DO RESULTADO DO PROCESSO */

PROCEDURE APATQP11_000
(P_NUMAUTO  IN  VARCHAR2
 ,P_NUMPROC IN VARCHAR2
,P_DATA_JULG IN VARCHAR2
,P_COD_RESULTADO IN VARCHAR2
,P_JUSTIFICATIVA IN VARCHAR2
 ,P_TIPOSERV IN VARCHAR2
,p_cod_retorno out number
,P_MENSAGEM OUT VARCHAR2)
 IS


W_COD_GRUP_ATDR T5590_PENALID_AIIP.COD_GRUP_ATDR%TYPE;
W_COD_SER_AIIP T5590_PENALID_AIIP.COD_SER_AIIP%TYPE;
W_COD_NRO_AIIP T5590_PENALID_AIIP.COD_NRO_AIIP%TYPE;
W_COD_DIGI_AIIP NUMBER;
W_COD_NRO_AIIPx VARCHAR2(6);
W_COD_DIGI_AIIPx  VARCHAR2(1);

W_DAC NUMBER;
W_COD_PLAC_VEIC T5591_RECURSO_DSV.COD_PLAC_VEIC%TYPE;
W_COD_MUNC_VEIC T5591_RECURSO_DSV.COD_MUNC_VEIC%TYPE;

W_DT_RSLT DATE;
W_COD_RSLT NUMBER(2);
W_COD_MTVO NUMBER(2);
W_NRO_AIT VARCHAR2(15);

W_COD_ORG_JLGD  NUMBER(2);
W_ANO_REC NUMBER(4);
W_COD_NRO_REC NUMBER(7);
 W_ANO_DEFS_PRV NUMBER(4);
W_COD_NRO_DEFS_PRV NUMBER(7);
W_TIP_SERV_DIGT NUMBER(2);

BEGIN  --1

/*

SET SERVEROUTPUT ON
SET AUTOPRINT ON
VAR P1 VARCHAR2(4)
VAR P2 VARCHAR2(300)

EXEC APATQP11.APATQP11_000('4VA15327684','A-000000000/2000','18/11/2025','01',' ','02',:P1,:P2);

EXEC APATQP11.APATQP11_000('4VA15327684','D-000000000/2000','18/11/2025','01',' ','01',:P1,:P2);

EXEC APATQP11.APATQP11_000('4VA15327684','01-J0000001/2025','18/11/2025','01',' ','03',:P1,:P2);

EXEC APATQP11.APATQP11_000('4VA15327684','02-C0000000/2025','18/11/2025','01',' ','04',:P1,:P2);

EXEC APATQP11.APATQP11_000('4VA15327862','D-000000000/2000','18/11/2025','01',' ','01',:P1,:P2);

EXEC APATQP11.APATQP11_000('4VA15327862','A-000000000/2000','18/11/2025','01',' ',02',:P1,:P2);

*/


P_COD_RETORNO := NULL;
P_MENSAGEM := NULL;

-- consistencia numauto


IF P_NUMAUTO IS NULL THEN

   P_COD_RETORNO := 1;
   P_MENSAGEM := 'Numero do auto invalido';
   GOTO SAIDA;
END IF;


IF LENGTH(P_NUMAUTO) <> 11 THEN
   P_COD_RETORNO := 1;
   P_MENSAGEM := 'Numero do auto invalido';
   GOTO SAIDA;
END IF;


W_COD_GRUP_ATDR := SUBSTR(P_NUMAUTO,1,2);
W_COD_SER_AIIP := SUBSTR(P_NUMAUTO,3,2);
W_COD_NRO_AIIPX := SUBSTR(P_NUMAUTO,5,6);
W_COD_DIGI_AIIPX := SUBSTR(P_NUMAUTO,11,1);


IF  LTRIM(W_COD_NRO_AIIPX,'1234567890') IS NOT NULL THEN
    P_COD_RETORNO := 1;
    P_MENSAGEM := 'Numero do auto invalido';
    GOTO SAIDA;
END IF;

IF  LTRIM(W_COD_DIGI_AIIPX,'1234567890') IS NOT NULL THEN
    P_COD_RETORNO := 1;
    P_MENSAGEM := 'Numero do auto invalido';
    GOTO SAIDA;
END IF;

W_COD_NRO_AIIP := TO_NUMBER(W_COD_NRO_AIIPX);
W_COD_DIGI_AIIP := TO_NUMBER(W_COD_DIGI_AIIPX);

-- dac

w_dac :=        udacaiip(W_COD_GRUP_ATDR,W_COD_SER_AIIP,W_COD_NRO_AIIP);

IF w_dac <> W_COD_DIGI_AIIP then
    P_COD_RETORNO := 1;
    P_MENSAGEM := 'Numero do auto invalido';
    GOTO SAIDA;
END IF;

-- 	CONSISTE SE NUMERO PROCESSO  APONTA PARA OUTRO AIT NA TABELA T11059

 BEGIN

SELECT cod_grup_atdr || cod_ser_aiip || LPAD(cod_nro_aiip,6,'0')||  udacaiip(COD_GRUP_ATDR,COD_SER_AIIP,COD_NRO_AIIP),
              COD_ORG_JLGD,
              ANO_REC,
              COD_NRO_REC,
              ANO_DEFS_PRV,
              COD_NRO_DEFS_PRV,
              TIP_SERV_DIGT
INTO       W_NRO_AIT,
              W_COD_ORG_JLGD,
              W_ANO_REC,
              W_COD_NRO_REC,
              W_ANO_DEFS_PRV,
              W_COD_NRO_DEFS_PRV,
              W_TIP_SERV_DIGT

FROM   T11059_PCS_SRV_DGT
WHERE
              COD_PCSS_SERV_DIGT = P_NUMPROC AND
              ROWNUM <2
ORDER BY DT_ATLZ_TAB DESC;


-- ERRO

IF W_NRO_AIT <> P_NUMAUTO THEN
    P_COD_RETORNO := 1;
    P_MENSAGEM := 'Numero do processo '||P_NUMPROC ||' cadastrado para outro Auto de infracao '||W_NRO_AIT;
    GOTO SAIDA;
END IF;

IF W_TIP_SERV_DIGT <> P_TIPOSERV THEN
    P_COD_RETORNO := 1;
    P_MENSAGEM := 'Tipo de servico divergente do cadastramento do processo ';
    GOTO SAIDA;


END IF;

-- se for igual esta OK


EXCEPTION
WHEN NO_DATA_FOUND THEN
    P_COD_RETORNO := 1;
    P_MENSAGEM := 'Numero do processo '||P_NUMPROC ||' nao cadastrado para o Auto de infracao '||P_NUMAUTO;
    GOTO SAIDA;

END;

dbms_output.put_line('P_NUMAUTO '||P_NUMAUTO );

dbms_output.put_line('P_NUMPROC '||P_NUMPROC );

dbms_output.put_line('P_DATA_JULG   '||P_DATA_JULG  );

dbms_output.put_line('P_COD_RESULTADO  '||P_COD_RESULTADO );

dbms_output.put_line('P_JUSTIFICATIVA '|| P_JUSTIFICATIVA );

dbms_output.put_line('P_TIPOSERV '||P_TIPOSERV );


/* NUMERO PROCESSO QUIPUX

ObrigatÃ³rio
EstÃ¡ composto por:

AdvertÃªncia:
Inicial da Ã¡rea/dependÃªncia responsÃ¡vel PAE (A)
Sequencial atribuÃ­do pelo sistema
Ano corrente
Exemplo: A-000000000/2000

Defesa:
Inicial da Ã¡rea/dependÃªncia responsÃ¡vel CDA (D)
Sequencial atribuÃ­do pelo sistema
Ano corrente
Exemplo: D-000000000/2000

IndicaÃ§Ã£o de condutor
Inicial do serviÃ§o solicitado
Sequencial atribuÃ­do pelo sistema
Ano corrente
Exemplo: I-000000000/2000

JARI
NÃºmero que identificÃ¡-la dependÃªncia JARI (01)
Inicial da dependÃªncia JARI
Sequencial atribuÃ­do pelo sistema
Ano corrente
Exemplo: 01-J0000000/2025

CETRAN
NÃºmero que identifica a dependÃªncia CETRAN (02)
Inicial da dependÃªncia CETRAN
Sequencial atribuÃ­do pelo sistema
Ano corrente
Exemplo: 02-C0000000/2025

*/

IF P_NUMPROC IS NULL OR
   LENGTH(P_NUMPROC) > 20  THEN
    P_COD_RETORNO := 1;
    P_MENSAGEM := 'Numero do processo invalido';
    GOTO SAIDA;
END IF;

IF SUBSTR(P_NUMPROC,1,2) NOT IN ('A-','D-','I-','01','02') THEN
    P_COD_RETORNO := 1;
    P_MENSAGEM := 'Numero do processo invalido';
    GOTO SAIDA;
END IF;

-- TIPO DE SERVICO
--01 defesa
--02 advertencia
--03 Jari
--04 Cetran
--05 Indicacao de condutor (OUTRO SERVICO ESPECIFICO)

IF P_TIPOSERV IS NULL THEN
    P_COD_RETORNO := 1;
    P_MENSAGEM := 'Tipo de servico invalido';
    GOTO SAIDA;
END IF;


IF P_TIPOSERV NOT IN ('01','02','03','04') THEN
    P_COD_RETORNO := 1;
    P_MENSAGEM := 'Tipo de servico invalido';
    GOTO SAIDA;
END IF;


-- DATA DE JULGAMENTO

IF P_DATA_JULG  IS NULL  THEN
    P_COD_RETORNO := 2;
    P_MENSAGEM := 'Data de Julgamento invalida';
    GOTO SAIDA;

END IF;

-- DATA  VALIDA

IF is_valid_date(P_DATA_JULG, 'DD/MM/YYYY') = 0 THEN

--  'Data Invalida'

    P_COD_RETORNO := 2;
    P_MENSAGEM := 'Data de Julgamento invalida';
    GOTO SAIDA;

END IF;

W_DT_RSLT := TO_DATE(P_DATA_JULG,'DD/MM/YYYY');

 IF TRUNC(W_DT_RSLT) > TRUNC(SYSDATE) THEN
     P_MENSAGEM := 'Data de Julgamento deve ser menor ou igual a data do dia';
       P_COD_RETORNO := 49;
       GOTO SAIDA;
  END IF;



-- P_COD_RESULTADO

IF P_COD_RESULTADO IS NULL OR
    LENGTH(P_COD_RESULTADO) > 2 THEN
    P_COD_RETORNO := 3;
    P_MENSAGEM := 'Codigo de resultado invalido';
    GOTO SAIDA;

END IF;

-- RESULTADOS ENVIADOS PELA QUIPUX TANTO PARA DEFESA QUANTO RECURSO
-- 01 INDEFERIDO
-- 02 DEFERIDO
-- 05 REJEITADO ADMINISTRATIVAMENTE - PARA ADVERTENCIA --> CONSIDERA INDEFERIDO
-- 05 REJEITADO ADMINISTRATIVAMENTE - PARA CETRAN --> CONSIDERA INDEFERIDO
IF P_COD_RESULTADO NOT IN ('01','02','05','1','2','5') THEN
    P_COD_RETORNO := 3;
    P_MENSAGEM :=  'Codigo de resultado invalido '||P_COD_RESULTADO;
    GOTO SAIDA;
END IF;

W_COD_RSLT := TO_NUMBER(P_COD_RESULTADO);

IF P_TIPOSERV = '01'  AND -- DEFESA
    W_COD_RSLT = 5 THEN  -- REJEITADO ADMINISTRATIVAMENTE

       W_COD_RSLT := 3; -- O RESULTADO REJEITADO ADMINISTRATIVAMENTE DA DEFESA = 3 E NAO 5

END IF;

IF P_TIPOSERV = '02'  AND -- SOL ADVERTENCIA
    W_COD_RSLT = 5 THEN  -- REJEITADO ADMINISTRATIVAMENTE -- Alterada em 04/02/2026

       W_COD_RSLT := 1;  -- assume resultado 1 indeferido pois no APAIT nÃ£o tem resultado rejeitado adm para solicitacao de advertencia

END IF;


IF P_TIPOSERV = '04'  AND -- CETRAN
     W_COD_RSLT = 5 THEN  -- REJEITADO ADMINISTRATIVAMENTE -- Alterada em 04/02/2026

       W_COD_RSLT := 1;  -- assume resultado 1 indeferido pois no APAIT nÃ£o tem resultado rejeitado adm para cetran

END IF;

-- P_JUSTIFICATIVA
IF  W_COD_RSLT IN (3, 5) AND 
   ( P_JUSTIFICATIVA IS NULL  OR
    LENGTH(P_JUSTIFICATIVA) > 2 ) THEN
    P_COD_RETORNO := 4;
    P_MENSAGEM :=  'Justificativa invalida = *'||  P_JUSTIFICATIVA ||'*';
    GOTO SAIDA;
END IF;

/*
1-Falta assinatura
2-Faltam documentos obrigatórios
7- Defesa não condiz com a autuação
8-Não se trata de recurso de multa
11-Ilegitimidade de parte
99-Outros motivos conforme parecer
*/

IF W_COD_RSLT IN(3, 5) THEN 

    W_COD_MTVO := TO_NUMBER(P_JUSTIFICATIVA);

    IF W_COD_MTVO NOT IN (1,2,7,8, 11, 99) THEN

       P_COD_RETORNO := 4;
       P_MENSAGEM :=  'Justificativa invalida = *'||  P_JUSTIFICATIVA ||'*';

       GOTO SAIDA;
    END IF;

-- CORRELACAO ENTRE O MOTIVO DE REJEICAO ADMINISTRATIVA  QUIPUX E APAIT
-- SOMENTE DEFESA TEM OUTROS CODIGOS NA TABELA T5496_MTV_CANC - EVENTO = 12
-- MOTIVOS DE REJEICAO ADM DE RECURSO NA T5496 - EVENTO = 06
-- O RESULTADO REJEITADO ADMINISTRATIVAMENTE DA DEFESA = 3 E NAO 5

  IF P_TIPOSERV = '01' THEN  -- DEFESA 

      IF W_COD_MTVO = 1 THEN
          W_COD_MTVO := 4;

      ELSIF W_COD_MTVO = 2 THEN
          W_COD_MTVO := 3;

      ELSIF W_COD_MTVO = 7 THEN
          W_COD_MTVO := 20;

      ELSIF W_COD_MTVO = 8 THEN
          W_COD_MTVO := 2;

      ELSIF W_COD_MTVO = 99 THEN
          W_COD_MTVO := 21;
      END IF;

  END IF;

-- CORRELACAO MOTIVO REJEICAO ADMINISTRATIVA DE RECURSOS
  IF P_TIPOSERV IN ('03', '04') THEN  -- RECURSO JARI E CETRAN

      IF W_COD_MTVO = 11 THEN
          W_COD_MTVO := 12;
      END IF;

  END IF;

END IF;


-- DIRECIONA PARA TRATAMENTO ESPECIFICO

IF P_TIPOSERV IN ( '01' ,'02')  THEN -- DEFESA  OU SOL ADVERTENCIA

    APATQP11.APATQP11_100(
                 W_COD_GRUP_ATDR,
						  	 W_COD_SER_AIIP,
                 W_COD_NRO_AIIP,
                 P_NUMPROC,
                 W_DT_RSLT,
                 W_COD_RSLT,
                 W_COD_MTVO,
                 P_TIPOSERV,
                 W_ANO_DEFS_PRV,
                 W_COD_NRO_DEFS_PRV,
                 P_COD_RETORNO,
                 P_MENSAGEM
            );

    GOTO SAIDA;

END IF;


IF P_TIPOSERV IN ( '03','04') THEN -- RECURSO JARI OU CETRAN


    APATQP11.APATQP11_300(
                 W_COD_GRUP_ATDR,
						  	 W_COD_SER_AIIP,
                 W_COD_NRO_AIIP,
                 P_NUMPROC,
                 W_DT_RSLT,
                 W_COD_RSLT,
                 W_COD_MTVO,
                 P_TIPOSERV,
                 W_COD_ORG_JLGD,
                 W_ANO_REC,
                 W_COD_NRO_REC,
                 P_COD_RETORNO,
                 P_MENSAGEM
                );

END IF;



<<SAIDA>>

IF P_COD_RETORNO IS NOT NULL THEN
    P_COD_RETORNO := P_COD_RETORNO + 1100;
END IF;



END;  -- 1

-- REGISTRA O RESULTADO DA DEFESA OU SOLICITACAO DE ADVERTENCIA
PROCEDURE APATQP11_100
(P_COD_GRUP_ATDR IN T5560_AIIP_CONSIST.COD_GRUP_ATDR%TYPE
,P_COD_SER_AIIP  IN T5560_AIIP_CONSIST.COD_SER_AIIP%TYPE
,P_COD_NRO_AIIP IN  T5560_AIIP_CONSIST.COD_NRO_AIIP%TYPE
,P_NUMPROC IN VARCHAR2
,P_DT_JLGM_DEFS_PRV IN  T5738_DEFES_PREVIA.DT_JLGM_DEFS_PRV%TYPE
,P_COD_RSLT_DEFS_PRV IN T5738_DEFES_PREVIA.COD_RSLT_DEFS_PRV%TYPE
,P_COD_MTVO_CANC IN T5738_DEFES_PREVIA.COD_MTVO_CANC%TYPE
,P_TIPOSERV IN VARCHAR2
,P_ANO_DEFS_PRV IN T5738_DEFES_PREVIA.ANO_DEFS_PRV%TYPE
,P_COD_NRO_DEFS_PRV IN T5738_DEFES_PREVIA.COD_NRO_DEFS_PRV%TYPE
,p_cod_retorno out number
,P_MENSAGEM OUT VARCHAR2
 ) IS

w_cod_idt_evto_canc number(2);
w_cod_tip_recb_defs          T5738_DEFES_PREVIA.cod_tip_recb_defs%TYPE;
W_COD_RSLT_DEFS_PRV T5738_DEFES_PREVIA.COD_RSLT_DEFS_PRV%TYPE;
W_COD_MTVO_CANC       T5738_DEFES_PREVIA.COD_MTVO_CANC%TYPE;
W_DT_JLGM_DEFS_PRV  T5738_DEFES_PREVIA.DT_JLGM_DEFS_PRV%TYPE;
W_COD_AREA_JLGD        T5738_DEFES_PREVIA.COD_AREA_JLGD %TYPE;
W_COD_TIP_DOC_AUTC   T5738_DEFES_PREVIA.COD_TIP_DOC_AUTC%TYPE;
W_COD_SITU_DEFS_PRV T5738_DEFES_PREVIA.COD_SITU_DEFS_PRV%TYPE;
W_COD_NRO_DEFS_PRV T5738_DEFES_PREVIA.COD_NRO_DEFS_PRV%TYPE;
W_DT_SOLI_DEFS_PRV    T5738_DEFES_PREVIA.DT_SOLI_DEFS_PRV%TYPE;
W_COD_GRUP_ATDR        T5738_DEFES_PREVIA.COD_GRUP_ATDR%TYPE;
W_COD_SER_AIIP             T5738_DEFES_PREVIA.COD_SER_AIIP%TYPE;
W_COD_NRO_AIIP             T5738_DEFES_PREVIA.COD_NRO_AIIP%TYPE;
W_SA_ANO                        T5738_DEFES_PREVIA.ANO_DEFS_PRV%TYPE;
W_SA_NRO                        T5738_DEFES_PREVIA.COD_NRO_DEFS_PRV%TYPE;
W_SA_EXISTE                    VARCHAR2(1);
W_SA_SITU                        T5738_DEFES_PREVIA.COD_SITU_DEFS_PRV%TYPE;
W_SA_RES                        T5738_DEFES_PREVIA.COD_RSLT_DEFS_PRV%TYPE;
W_DA_ANO                        T5738_DEFES_PREVIA.ANO_DEFS_PRV%TYPE;
W_DA_NRO                        T5738_DEFES_PREVIA.COD_NRO_DEFS_PRV%TYPE;
W_DA_EXISTE                    VARCHAR2(1);
W_DA_SITU                        T5738_DEFES_PREVIA.COD_SITU_DEFS_PRV%TYPE;
W_DA_RES                        T5738_DEFES_PREVIA.COD_RSLT_DEFS_PRV%TYPE;

W_CODIGO VARCHAR2(1);
W_ANO_DEFS_PRV T5738_DEFES_PREVIA.ANO_DEFS_PRV%TYPE;
W_RESULTADO VARCHAR2(100);
W_SITUACAO VARCHAR2(100);
W_COD_IDT_OPEA_CAD  T5738_DEFES_PREVIA.COD_IDT_OPEA_CAD%TYPE;
w_ind_emis_avis_rslt T5738_DEFES_PREVIA.ind_emis_avis_rslt%TYPE;

BEGIN  -- 1

-- OBTER DADOS DA TABELA T5738_DEFES_PREVIA CADASTRADA EM T11059
-- em 02/04/2026 colocamos TO_CHAR na pesquisa do ST1643_REFCODES, pois deu erro em producao

BEGIN  --2

    SELECT            COD_SITU_DEFS_PRV,
                      ANO_DEFS_PRV,
                      COD_NRO_DEFS_PRV,
                      cod_tip_recb_defs,
                      COD_RSLT_DEFS_PRV,
                      COD_MTVO_CANC,
                      DT_JLGM_DEFS_PRV,
                      COD_AREA_JLGD,
                      COD_TIP_DOC_AUTC,
                      DECODE(COD_RSLT_DEFS_PRV,1,'01 - Indeferido',2,'02 - Deferido',3,'03 - Rejeitado Administrativamente',' '), -- Alterado em 04/02/2026
                      DT_SOLI_DEFS_PRV,
                      COD_IDT_OPEA_CAD,
                      COD_GRUP_ATDR,
                      COD_SER_AIIP,
                      COD_NRO_AIIP
    INTO              W_COD_SITU_DEFS_PRV,
                      W_ANO_DEFS_PRV,
                      W_COD_NRO_DEFS_PRV,
                      w_cod_tip_recb_defs,
                      W_COD_RSLT_DEFS_PRV,
                      W_COD_MTVO_CANC,
                      W_DT_JLGM_DEFS_PRV,
                      W_COD_AREA_JLGD,
                      W_COD_TIP_DOC_AUTC,
                      W_RESULTADO,
                      W_DT_SOLI_DEFS_PRV,
                      W_COD_IDT_OPEA_CAD,
                      W_COD_GRUP_ATDR,
                      W_COD_SER_AIIP,
                      W_COD_NRO_AIIP
    FROM T5738_DEFES_PREVIA
    WHERE
                  ANO_DEFS_PRV = P_ANO_DEFS_PRV AND
                  COD_NRO_DEFS_PRV = P_COD_NRO_DEFS_PRV;


    BEGIN

        SELECT TRIM(RV_MEANING)
        INTO W_SITUACAO
        FROM ST1643_REF_CODES
        WHERE
        RV_LOW_VALUE = TO_CHAR(W_COD_SITU_DEFS_PRV)
        AND
        RV_DOMAIN = 'SITUACAO DEFESA PREVIA'
        AND ROWNUM <2;


    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            W_SITUACAO := W_COD_SITU_DEFS_PRV;
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20202,'Erro '||SQLERRM||' no SELECT do ST1643_REF_CODES - APATQP11_100 - Chave: '||
                p_cod_grup_atdr||'-'||p_cod_ser_aiip||'-'|| p_cod_nro_aiip || ' situacao: ' || W_COD_SITU_DEFS_PRV);

    END;


EXCEPTION

    WHEN NO_DATA_FOUND THEN
      P_COD_RETORNO := 46;
      p_mensagem := 'Defesa de autuacao nao localizada';
      GOTO SAIDA;

    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20202,'Erro '||SQLERRM||' no SELECT do T5738 - APATQP11_100 - Chave: '||
            'ANO DEFESA: ' || P_ANO_DEFS_PRV || ' COD_NRO_DEFS_PRV: ' || P_COD_NRO_DEFS_PRV);

END;  -- 2

BEGIN   -- 3

-- CONSISTENCIA


IF   w_cod_tip_recb_defs <> 'W' THEN
     P_MENSAGEM :='Este processo nao foi cadastrado pelo portal';
     P_COD_RETORNO := 48;
     GOTO saida;
END IF;


IF P_DT_JLGM_DEFS_PRV < W_DT_SOLI_DEFS_PRV  THEN

    P_COD_RETORNO := 52;
    p_mensagem := 'Data de julgamento deve ser posterior a data de cadastramento do processo - ' || to_char(w_dt_soli_defs_prv,'dd/mm/yyyy');
   GOTO SAIDA;


END IF;


IF W_COD_SITU_DEFS_PRV NOT IN (4,6,10,11)  THEN -- EM ANALISE / RETORNO DE DILIGENCIA / AGUARDA PROCESSAMENTO / PROCESSADO

    P_COD_RETORNO := 47;
    p_mensagem := 'Situacao do processo nao permite cadastrar resultado - ' ||W_situacao;
   GOTO SAIDA;

END IF;



-- SituaÃ§Ã£o 10 ou 11 -  jÃ¡ tem resultado - tratar como Ok, sem erro

IF P_COD_RSLT_DEFS_PRV = W_COD_RSLT_DEFS_PRV AND
   NVL(P_COD_MTVO_CANC,0) = NVL(W_COD_MTVO_CANC,0) AND
   P_DT_JLGM_DEFS_PRV = w_DT_JLGM_DEFS_PRV AND
   W_cod_situ_defs_prv IN ( 10,11) THEN                  -- Liberada para Processar Resultado / Resultado processado

   P_MENSAGEM := NULL;
   P_COD_RETORNO := NULL;  -- OK J ? PROCESSADO

   GOTO SAIDA;
END IF;



IF   W_cod_situ_defs_prv = 10 or  -- Resultado liberado para ser Processado
     W_cod_situ_defs_prv = 11   THEN    --  Resultado Processado

      -- se resultado do parametro <> resultado da tabela T5738

     IF P_COD_RSLT_DEFS_PRV <> W_COD_RSLT_DEFS_PRV  OR
        P_DT_JLGM_DEFS_PRV <> w_DT_JLGM_DEFS_PRV   THEN
        P_MENSAGEM :='Resultado informado: '||w_resultado||
       ' diverge do resultado anterior: '|| W_COD_RSLT_DEFS_PRV||' em ' || TO_CHAR(w_DT_JLGM_DEFS_PRV,'dd/mm/yyyy');

        P_COD_RETORNO := 50;
        GOTO SAIDA;

     END IF;

-- se motivo do resultado rejeitado do parametro <> motivo do resultado rejeitado da tabela

     IF P_COD_RSLT_DEFS_PRV =  3 AND
        P_COD_MTVO_CANC <> W_COD_MTVO_CANC     THEN
        P_MENSAGEM :='Resultado Rejeitado administrativamente em '||
        TO_CHAR(w_DT_JLGM_DEFS_PRV,'dd/mm/yyyy')||' processado com motivo divergente: '||w_cod_mtvo_canc;

        P_COD_RETORNO := 51;
        GOTO saida;
     END IF;

END IF;


/* SITUACAO DE DEFESA / ADVERTENCIA
RV_DOMAIN = 'SITUACAO DEFESA PREVIA'

1 - Pendente de LiberaÃ§Ã£o
2 - Aguardando InstruÃ§Ã£o
3 - Liberada para AnÃ¡lise
4 - Em AnÃ¡lise
5 - Em DiligÃªncia
6 - Retorno de DiligÃªncia
7 - Em DigitaÃ§Ã£o de Resultado
8 - Resultado Digitado
9 - Aguardando Despacho do Diretor
10 - Liberada para Processar Resultado
11 - Resultado Processado
12 - Cancelada
*/

  -- Atribui valor a cod_evto_canc

   IF p_cod_mtvo_canc IS NULL THEN
      w_cod_idt_evto_canc := NULL;
   ELSE
      w_cod_idt_evto_canc := 12;
   END IF;

-- ATUALIZA O RESULTADO DA DEFESA
-- NAO POSSUIRA NUMERO DO DESPACHO NO APAIT

w_ind_emis_avis_rslt := NULL;

IF P_TIPOSERV =  '01'   and -- DEFESA
    P_cod_rslt_defs_prv = 2 THEN
   w_ind_emis_avis_rslt := 'S' ;
END IF;

dbms_output.put_line('ANO / NRO '||W_ano_defs_prv ||' '|| W_cod_nro_defs_prv  );


  update t5738_defes_previa
       set   cod_idt_cmpc_rslt = 'C',
              cod_reg_fun_usua  =  W_COD_IDT_OPEA_CAD,
              dt_dgta_rslt_defs = sysdate,
              dt_jlgm_defs_prv   = P_dt_jlgm_defs_prv,
              cod_rslt_defs_prv  = P_cod_rslt_defs_prv,
              cod_idt_opea       =  W_COD_IDT_OPEA_CAD,
              dt_atlz_tab        = sysdate,
              cod_seq_dgta_rslt  = NULL,
              cod_situ_defs_prv  = 10,
              cod_idt_evto_canc  = w_cod_idt_evto_canc,
              cod_mtvo_canc      = p_cod_mtvo_canc,
              ano_dpch_defs_prv  = NULL,
              cod_nro_dpch_defs = NULL,
              ind_emis_avis_rslt = w_ind_emis_avis_rslt

       where  ano_defs_prv       = W_ano_defs_prv
       and    cod_nro_defs_prv   = W_cod_nro_defs_prv;



IF  w_cod_tip_doc_autc in (1,2) THEN  -- DEFESA
    W_CODIGO := 'J';

ELSIF  w_cod_tip_doc_autc = 4 THEN  -- DEFESA AIT NIC

    W_CODIGO := 'L';
ELSE
    W_CODIGO :='G';  -- 3 SOL. ADVERTENCIA
END IF;


END;  -- 3

BEGIN  -- 4

   INSERT INTO  t5913_tot_defs_prv
                (dt_ref_defs_prv
                ,cod_tip_tot_defs
                ,cod_area_tram
                ,cod_rslt_defs_prv
                ,qtd_tot_defs_prv
                ,dt_atlz_tab)
   values      (p_dt_jlgm_defs_prv,
                W_CODIGO,
                w_cod_area_jlgd,
                p_cod_rslt_defs_prv,
                1,
                trunc(Sysdate));


EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
BEGIN  --5

 UPDATE t5913_tot_defs_prv
   SET qtd_tot_defs_prv = qtd_tot_defs_prv + 1,
       dt_atlz_tab = TRUNC(SYSDATE)
   WHERE
   dt_ref_defs_prv= P_dt_jlgm_defs_prv and
   cod_tip_tot_defs = w_codigo and
   cod_area_tram = w_cod_area_jlgd and
   cod_rslt_defs_prv = p_cod_rslt_defs_prv;

END;  --5

END;  --4

COMMIT;

-- VERIFICA SE PODE TRATAR RESULTADO IMEDIATAMENTE OU NAO
-- PROCESSADO RESULTADO DEFESA DEFERIDA IMEDIATAMENTE MESMO QUE TENHA SOL ADVERTENCIA NAO JULGADA
-- SE SITUACAO DO T5738 VOLTAR COM 11 FOI PROCESSADO  O RESULTADO
-- SE SITUACAO DO T5738 FICAR COM 10 DEVE HAVER CONDICOES PRECEDENTES A SEREM CUMPRIDAS ANTES DE PROCESSAR O RESULTADO
-- EXEMPLO - ESTAR AINDA NO PRAZO PARA ENTRAR COM DEFESA OU SOL ADVERTENCIA
-- EXEMPLO - TER O OUTRO PROCESSO AINDA NAO JULGADO


IF P_TIPOSERV =  '02'    THEN -- SOL ADVERTENCIA
    GOTO SOLICADV;
END IF;

-- PROCESSAR RESULTADO DA DEFESA DE AUTUACAO

APAT3P03.APAT3P03_200(
                      w_ANO_DEFS_PRV,
                      w_COD_NRO_DEFS_PRV
                      );

IF p_cod_rslt_defs_prv = 2 THEN -- DEFESA DEFERIDA JA CANCELOU O AIT
   GOTO SAIDA;
END IF;

-- VERIFICA SE EXISTE SOLICITACAO DE ADVERTENCIA

APATQP11.APATQP11_110(
                    W_COD_GRUP_ATDR,
                    W_COD_SER_AIIP,
                    W_COD_NRO_AIIP,
                    3,
                    W_SA_ANO,
                    W_SA_NRO,
                    W_SA_EXISTE,
                    W_SA_SITU,
                    W_SA_RES
                    );

-- SE EXISTIR SOL ADVERTENCIA AGUARDANDO RESULTADO DA DEFESA, SA DEVE SER PROCESSADA

IF W_SA_EXISTE = 'S' AND
    W_SA_SITU = 10 THEN

    APAT3P17.APAT3P17_200(
                          W_SA_ANO,
                          W_SA_NRO
                          );

END IF;

GOTO SAIDA;

<<SOLICADV>>




-- VERIFICA SE EXISTE DEFESA DE AUTUACAO

APATQP11.APATQP11_110(
                      W_COD_GRUP_ATDR,
                      W_COD_SER_AIIP,
                      W_COD_NRO_AIIP,
                      1,
                      W_DA_ANO,
                      W_DA_NRO,
                      W_DA_EXISTE,
                      W_DA_SITU,
                      W_DA_RES
                      );


-- SE EXISTIR DEFESA AGUARDANDO PARA PROCESSAR O RESULTADO

IF W_DA_EXISTE = 'S' AND
    W_DA_SITU = 10 THEN


      APAT3P03.APAT3P03_200(
                            W_DA_ANO,
                            W_DA_NRO);

END IF;

-- PROCESSAR RESULTADO DA SOL ADVERTENCIA


    APAT3P17.APAT3P17_200(
                          w_ANO_DEFS_PRV,
                          w_COD_NRO_DEFS_PRV
                        );


<<SAIDA>>

NULL;



END;  -- 1

-- OBTER PROCESSO DE DEFESA OU SOL. ADVERTENCIA

PROCEDURE APATQP11_110
 (P_COD_GRUP_ATDR IN T5559_AIIP_OUTROS.COD_GRUP_ATDR%TYPE
 ,P_COD_SER_AIIP IN T5559_AIIP_OUTROS.COD_SER_AIIP%TYPE
 ,P_COD_NRO_AIIP IN T5559_AIIP_OUTROS.COD_NRO_AIIP%TYPE
 ,P_COD_TIP_DOC_AUTC IN  T5738_DEFES_PREVIA.COD_TIP_DOC_AUTC%TYPE
 ,P_ANO OUT T5738_DEFES_PREVIA.ANO_DEFS_PRV%TYPE
 ,P_NRO OUT T5738_DEFES_PREVIA.COD_NRO_DEFS_PRV%TYPE
 ,P_EXISTE OUT VARCHAR2
 ,P_SITU OUT T5738_DEFES_PREVIA.COD_SITU_DEFS_PRV%TYPE
 ,P_RES OUT T5738_DEFES_PREVIA.COD_RSLT_DEFS_PRV%TYPE
 )
 IS

-- APATQP11_110 - OBTER PROCESSO DE DEFESA OU SOL. ADVERTENCIA

BEGIN

  SELECT  ano_defs_prv,
          cod_nro_defs_prv,
          cod_situ_defs_prv,
          cod_rslt_defs_prv,
          'S'
  INTO P_ANO,
          P_NRO,
          P_SITU,
          P_RES,
          P_EXISTE
  FROM    t5738_DEFES_PREVIA
  WHERE   cod_grup_atdr = p_cod_grup_atdr
  AND     cod_ser_aiip  = p_cod_ser_aiip
  AND     cod_nro_aiip  = p_cod_nro_aiip
  AND     cod_situ_defs_prv <> 12
  AND    (( cod_tip_doc_autc = 3 AND P_COD_TIP_DOC_AUTC = 3) OR
              ( cod_tip_doc_autc IN (1,2) AND P_COD_TIP_DOC_AUTC = 1))
  AND     DT_SOLI_DEFS_PRV IN
          (SELECT MAX(DT_SOLI_DEFS_PRV)      -- maior solicitaÃ§Ã£o interposta
           FROM   t5738_defes_previa t1
           WHERE  t1.cod_grup_atdr = p_cod_grup_atdr
             AND  T1.cod_ser_aiip  = p_cod_ser_aiip
             AND  t1.cod_nro_aiip  = p_cod_nro_aiip
             AND  ((t1.cod_tip_doc_autc = 3 AND P_COD_TIP_DOC_AUTC = 3)  OR
                       (t1.cod_tip_doc_autc IN (1,2) AND P_COD_TIP_DOC_AUTC = 1))
             AND  t1.cod_situ_defs_prv <> 12);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
          P_ANO:= NULL;
          P_NRO:= NULL;
          P_SITU:= NULL;
          P_RES:= NULL;
          P_EXISTE:= 'N';

  WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20202,'Erro '||SQLERRM||' no SELECT da T5738 - APATQP11_110 - Chave: '||
                               p_cod_grup_atdr||'-'||p_cod_ser_aiip||'-'|| p_cod_nro_aiip);
END;


-- resultado jari - cetran

PROCEDURE APATQP11_300
(P_COD_GRUP_ATDR IN T5560_AIIP_CONSIST.COD_GRUP_ATDR%TYPE
,P_COD_SER_AIIP  IN T5560_AIIP_CONSIST.COD_SER_AIIP%TYPE
,P_COD_NRO_AIIP IN  T5560_AIIP_CONSIST.COD_NRO_AIIP%TYPE
,P_NUMPROC IN VARCHAR2
,P_DT_RSLT_REC IN  T5591_RECURSO_DSV.DT_RSLT_REC%TYPE
,P_COD_RSLT_REC_PENA IN T5591_RECURSO_DSV.COD_RSLT_REC_PENA%TYPE
,P_COD_MTVO_RJCO_ADMI   IN T5591_RECURSO_DSV.COD_MTVO_RJCO_ADMI%TYPE
,P_TIPOSERV IN VARCHAR2
,P_COD_ORG_JLGD IN  T5591_RECURSO_DSV.COD_ORG_JLGD%TYPE
,P_ANO_REC IN T5591_RECURSO_DSV.ANO_REC%TYPE
,P_COD_NRO_REC IN  T5591_RECURSO_DSV.COD_NRO_REC%TYPE
,p_cod_retorno out number
,P_MENSAGEM OUT VARCHAR2
 ) IS


W_COD_RSLT_REC_PENA T5591_RECURSO_DSV.COD_RSLT_REC_PENA%TYPE;
W_DT_RSLT_REC T5591_RECURSO_DSV.DT_RSLT_REC%TYPE;
w_cod_idt_evto_canc number(2);
W_COD_AREA_JLGD  T5591_RECURSO_DSV.COD_AREA_JLGD %TYPE;
W_COD_SITU_REC  T5591_RECURSO_DSV.COD_SITU_REC%TYPE;
W_COD_NRO_REC  T5591_RECURSO_DSV.COD_NRO_REC%TYPE;
W_CODIGO VARCHAR2(1);
W_ANO_REC  T5591_RECURSO_DSV.ANO_REC%TYPE;
W_COD_ORG_JLGD  T5591_RECURSO_DSV.COD_ORG_JLGD%TYPE;
W_RESULTADO VARCHAR2(100);
W_COD_MTVO_RJCO_ADMI  T5591_RECURSO_DSV.COD_MTVO_RJCO_ADMI%TYPE;
W_TXT_MTVO_REC_RJET T5591_RECURSO_DSV.TXT_MTVO_REC_RJET%TYPE;
w_cod_tip_recb_rec T5591_RECURSO_DSV.cod_tip_recb_rec%TYPE;
w_mensagem VARCHAR2(100);
W_SITUACAO VARCHAR2(100);
W_DT_ITPS_REC DATE;
W_COD_OPEA_CADT_REC  T5591_RECURSO_DSV.COD_OPEA_CADT_REC%TYPE;


BEGIN

P_MENSAGEM := NULL;
P_COD_RETORNO := NULL;

/* SITUACAO RECURSO

3 - Protocolado
4 - Aguarda DistribuiÃ§Ã£o
5 - Julgamento
6 - DiligÃªncia solicitada pelo membro da JARI
7 - Diligencia Interna
8 - DiligÃªncia ao Recorrente
9 - Diligencia Externa
10 - Retorno de DiligÃªncia ao Recorrente
11 - Resultado digitado ainda nÃ£o processado
12 - Aguardando DSV entrar em 2a. instÃ¢ncia
13 - Resultado Processado 1a. instÃ¢ncia
15 - Resultado Processado 2a. instÃ¢ncia
17 - Cancelado
18 - Juizo de RetrataÃ§Ã£o JARI
19 - 2a. instÃ¢ncia DSV interposta
21 - DiligÃªncia Interna a JARI
25 - Em digitaÃ§Ã£o de resultado
27 - Retorno de PrescriÃ§Ã£o
29 - Retorno de DiligÃªncia Interna
31 - Retorno de DiligÃªncia Externa
33 - Retorno de DiligÃªncia Interna a Jari
35 - 2a. instancia DSV julgada
37 - Resultado liberado por prazo
39 - Resultado liberado pelo DSV
41 - Resultado de RevisÃ£o do CETRAN
43 - Recurso rejeitado administrativamente

*/



-- OBTER DADOS DA TABELA T5591_RECURSO_DSV DOS DADOS DA T11059

BEGIN  --2

SELECT            COD_SITU_REC,
                  COD_ORG_JLGD,
                  ANO_REC,
                  COD_NRO_REC,
                  COD_RSLT_REC_PENA,
                  DT_RSLT_REC,
                  COD_AREA_JLGD,
                  COD_MTVO_RJCO_ADMI,
                  TXT_MTVO_REC_RJET,
                  cod_tip_recb_rec,
                  dt_itps_rec,
                  COD_OPEA_CADT_REC

INTO              W_COD_SITU_REC,
                  W_COD_ORG_JLGD,
                  W_ANO_REC,
                  W_COD_NRO_REC,
                  W_COD_RSLT_REC_PENA,
                  W_DT_RSLT_REC,
                  W_COD_AREA_JLGD,
                  W_COD_MTVO_RJCO_ADMI,
                  W_TXT_MTVO_REC_RJET,
                  w_cod_tip_recb_rec,
                  w_dt_itps_rec,
                  W_COD_OPEA_CADT_REC
FROM        T5591_RECURSO_DSV T5591
WHERE
                  COD_ORG_JLGD = P_COD_ORG_JLGD AND
                  ANO_REC = P_ANO_REC AND
                  COD_NRO_REC = P_COD_NRO_REC ;

/*T5591.COD_TIP_pENA = T5590.COD_TIP_PENA AND
T5591.COD_NRO_PENA = T5590.COD_NRO_PENA AND
T5590.COD_GRUP_ATDR = P_COD_GRUP_ATDR AND
T5590.COD_SER_AIIP = P_COD_SER_AIIP AND
T5590.COD_NRO_AIIP = P_COD_NRO_AIIP AND
T5591.COD_SITU_REC NOT IN (17) AND
ROWNUM <2
ORDER BY COD_ORG_JLGD DESC,DT_CAD_REC DESC; -- ULTIMO RECURSO */

-- em 02/04/2026 colocamos TO_CHAR na pesquisa do ST1643_REFCODES, pois deu erro em producao

BEGIN

    SELECT RV_MEANING
    INTO W_SITUACAO
    FROM ST1643_REF_CODES
    WHERE
    RV_LOW_VALUE = TO_CHAR(W_COD_SITU_REC)
    AND
    RV_DOMAIN = 'SITUACAO RECURSO'
    AND ROWNUM <2;


    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          W_SITUACAO := W_COD_SITU_REC;

      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20202,'Erro '||SQLERRM||' no SELECT do ST1643_REF_CODES - APATQP11_300 - Chave: '||
            p_cod_grup_atdr||'-'||p_cod_ser_aiip||'-'|| p_cod_nro_aiip || ' situacao: ' || W_COD_SITU_REC);

    END;

    EXCEPTION

    WHEN NO_DATA_FOUND THEN
      P_COD_RETORNO := 52;
      p_mensagem := 'Recurso nao localizado';
      GOTO SAIDA;

    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20202,'Erro '||SQLERRM||' no SELECT do T5591 - APATQP11_300 - Chave: '||
            'COD_ORG_JLGD: ' || P_COD_ORG_JLGD || ' ANO RECURSO: ' || P_ANO_REC || ' COD_NRO_REC: ' || P_COD_NRO_REC);

END;  -- 2

 begin


dbms_output.put_line('ORGAO / ANO / NRO '||W_COD_ORG_JLGD ||' '|| W_ANO_REC ||' '|| W_COD_NRO_REC  );


-- CONSISTENCIA


IF   w_cod_tip_recb_rec <> 'W' THEN
     P_MENSAGEM :='Este processo nao foi cadastrado pelo portal';
     P_COD_RETORNO := 53;
     GOTO saida;
END IF;



IF P_DT_RSLT_REC < W_DT_ITPS_REC  THEN

    P_COD_RETORNO := 55;
    p_mensagem := 'Data de julgamento deve ser posterior a data de cadastramento do processo - ' || to_char(w_dt_itps_rec,'dd/mm/yyyy');
   GOTO SAIDA;


END IF;


/* 13/03/2026 - incluido o W_COD_SITU_REC = 11 (Resultado digitado ainda nao processado) - para tratar os casos onde o resultado do recurso   enviado mais de uma vez */
IF W_COD_SITU_REC NOT IN (3,4, 5,7,9,21,25,29,31,33,27,13,15,11)  THEN
-- PROTOCOLADO / AGUARDA DISTRIBUICAO / EM ANALISE / RETORNO DE DILIGENCIA / AGUARDA PROCESSAMENTO / PROCESSADO

    P_COD_RETORNO := 54;
    p_mensagem := 'Situacao do processo nao permite cadastrar resultado - ' ||W_SITUACAO;
   GOTO SAIDA;

END IF;

-- EXISTIA DILIGENCIA EM ABERTO E DEVE SER FINALIZADA

IF  w_cod_situ_rec in (7,9,21) then

          UPDATE t5618_diligencia
                 SET  dt_ret_dlgn        =    P_dt_rslt_rec,
                           cod_idt_opea       =    W_COD_OPEA_CADT_REC,
                           dt_atlz_tab        =     SYSDATE
           WHERE cod_org_jlgd       =    W_cod_org_jlgd
                 AND ano_rec            =    W_ano_rec
                 AND cod_nro_rec        =   W_cod_nro_rec
                 AND dt_ret_dlgn        is   null  ;

END IF;


-- SituaÃ§Ã£o 11, 13 OU 15 -  jÃ¡ tem resultado - tratar como Ok, sem erro

IF P_COD_RSLT_REC_PENA = W_COD_RSLT_REC_PENA AND
   NVL(P_COD_MTVO_RJCO_ADMI,0) = NVL(W_COD_MTVO_RJCO_ADMI,0) AND
   P_DT_RSLT_REC = w_DT_RSLT_REC AND
   W_COD_SITU_REC IN ( 11, 13,15) THEN                  -- Liberada para Processar Resultado / Resultado processado

   P_MENSAGEM := NULL;
   P_COD_RETORNO := NULL;  -- OK J ? PROCESSADO
   GOTO SAIDA;
END IF;



IF   W_cod_situ_rec = 11 or  -- Resultado liberado para ser Processado
     W_cod_situ_rec IN (13,15)   THEN    --  Resultado Processado

      -- se resultado do parametro <> resultado da tabela T5591

     IF P_COD_RSLT_REC_PENA <> W_COD_RSLT_REC_PENA  OR
        P_DT_RSLT_REC <> w_DT_RSLT_REC   THEN
        P_MENSAGEM :='Resultado informado: '||P_COD_RSLT_REC_PENA||' em '||TO_CHAR(p_DT_RSLT_REC,'dd/mm/yyyy') ||
       ' diverge do resultado anterior: '|| W_COD_RSLT_REC_PENA||' em ' || TO_CHAR(w_DT_RSLT_REC,'dd/mm/yyyy');

        P_COD_RETorno := 55;
        GOTO SAIDA;

     END IF;

-- se motivo do resultado rejeitado do parametro <> motivo do resultado rejeitado da tabela

     IF P_COD_RSLT_REC_PENA =  5 AND
        P_COD_MTVO_RJCO_ADMI <> W_COD_MTVO_RJCO_ADMI    THEN
        P_MENSAGEM :='Resultado Rejeitado administrativamente em '||
        TO_CHAR(w_DT_RSLT_REC,'dd/mm/yyyy')||' processado com motivo divergente: '||W_COD_MTVO_RJCO_ADMI;

        P_COD_RETORNO := 56;
        GOTO saida;
     END IF;


END IF;


  -- Atribui valor a cod_evto_canc



   IF P_COD_MTVO_RJCO_ADMI IS NULL THEN
      w_cod_idt_evto_canc := NULL;
      W_TXT_MTVO_REC_RJET := NULL;
   ELSE
       w_cod_idt_evto_canc := 6;
       W_TXT_MTVO_REC_RJET := NULL;

       IF P_COD_RSLT_REC_PENA = 5 THEN

           APATQP11.APATQP11_301(P_COD_MTVO_RJCO_ADMI,W_TXT_MTVO_REC_RJET);

       END IF;

   END IF;



 -- ATUALIZA O RESULTADO DO RECURSO

  UPDATE t5591_recurso_dsv
     SET  cod_situ_rec       =    11,
          cod_seq_dgta_rslt  =    NULL,
          cod_rslt_rec_pena  =   P_COD_RSLT_REC_PENA,
          cod_rslt_rec_indc  =  11,
          dt_rslt_rec        =   P_DT_RSLT_REC,
          cod_opea_rslt      =   COD_OPEA_CADT_REC,
          dt_atlz_tab_rslt   =    SYSDATE,
          cod_area_dgta_rslt =  NULL,
          cod_evto_canc_02   =   w_cod_idt_evto_canc,
          cod_mtvo_rjco_admi =    P_COD_MTVO_RJCO_ADMI,
          txt_mtvo_rec_rjet  =   W_TXT_MTVO_REC_RJET,
          cod_org_jlgd_dgta  =    NULL,
          COD_SITU_SELE_REC  =  NULL,
          cod_idt_opea       =   COD_OPEA_CADT_REC,
          dt_atlz_tab        =    SYSDATE,
          cod_memb_area_jlgd = null,
          QTD_VOTO_DECS_RSLT = null
    WHERE cod_org_jlgd       =   W_COD_ORG_JLGD
      AND ano_rec            =   W_ANO_REC
      AND cod_nro_rec        =    W_COD_NRO_REC;



INSERT INTO t5608_hst_situ_rec
             (cod_org_jlgd,
              ano_rec,
              cod_nro_rec,
              dt_atlc_rec,
              cod_situ_rec,
              cod_pgm)
      VALUES (W_COD_ORG_JLGD,
                     W_ANO_REC,
                     W_COD_NRO_REC,
                    TRUNC(SYSDATE),
                    11,
                    'APATQP11');


 INSERT INTO t5619_mvt_rec_lbrd
              (cod_org_jlgd,
               ano_rec,
               cod_nro_rec,
               ind_tip_rec,
               cod_rslt_rec_prcs)
       VALUES (W_COD_ORG_JLGD,
                     W_ANO_REC,
                     W_COD_NRO_REC,
                      'P',
                      NULL);


COMMIT;



end;

<<SAIDA>>

NULL;


END;



-- seleciona descricao t5496 motivo rejeicao adm - recurso multa - cod 6

PROCEDURE APATQP11_301
 (P_COD_MVTO_CANC IN T5496_MTV_CANC_MLT.COD_MTVO_CANC%TYPE
 ,P_TXT_MTVO_RJCO OUT T5496_MTV_CANC_MLT.TXT_MTVO_RJCO%TYPE ) IS

--  obtem descricao do motivo cancelamento
--  motivo de rejeicao administrativa de recurso de multa - cod 6

BEGIN

  SELECT txt_mtvo_rjco
    INTO p_txt_mtvo_rjco
    FROM T5496_MTV_CANC_MLT
    WHERE  cod_idt_evto_canc = 6
    AND    cod_mtvo_canc = p_cod_mvto_canc;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20201,'Nao localizou t5496  - APATQP11_301');
       ROLLBACK;

  WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20201,'Erro '||SQLCODE||' SELECT t5496- APATQP11_301');
     ROLLBACK;

END;


END APATQP11;

/
