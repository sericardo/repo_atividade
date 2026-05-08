CREATE OR REPLACE PACKAGE        APATQP04 IS

/* Procedure Principal - ENVIO DO REGISTRO DA SOLICITACAO */

PROCEDURE APATQP04_000
(P_NUMAUTO  IN  VARCHAR2
 ,P_NUMPROC IN VARCHAR2
 ,P_TIPOSERV IN VARCHAR2
,P_DATASOLICITACAO IN VARCHAR2
,P_PLATAFORMA IN VARCHAR2
,p_cod_retorno out number
,P_MENSAGEM OUT VARCHAR2
 );

END APATQP04;

/


CREATE OR REPLACE PACKAGE BODY    APATQP04 IS


/* Procedure Principal - ENVIO DO REGISTRO DA SOLICITACAO  */

PROCEDURE APATQP04_000
(P_NUMAUTO  IN  VARCHAR2
 ,P_NUMPROC IN VARCHAR2
 ,P_TIPOSERV IN VARCHAR2
,P_DATASOLICITACAO IN VARCHAR2
,P_PLATAFORMA IN VARCHAR2
,p_cod_retorno out number
,P_MENSAGEM OUT VARCHAR2
 )
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
W_DT_SOLIC DATE;
W_NRO_AIT VARCHAR2(15);
W_NRO_PROCESSO VARCHAR2(15);

BEGIN

/*

SET SERVEROUTPUT ON
SET AUTOPRINT ON
VAR P1 VARCHAR2(4)
VAR P2 VARCHAR2(300)

EXEC APATQP04.APATQP04_000('4VA15327684','A-000000000/2000','02','01/12/2025','01',:P1,:P2);

EXEC APATQP04.APATQP04_000('4VA15327684','D-000000000/2000','01','01/12/2025','01',:P1,:P2);

EXEC APATQP04.APATQP04_000('4VA15327684','01-J0000000/2025','03','01/12/2025','01',:P1,:P2);

EXEC APATQP04.APATQP04_000('4VA15327684','02-C0000000/2025','04','01/12/2025','01',:P1,:P2);

EXEC APATQP04.APATQP04_000('4VA15327862','D-000000000/2000','01','01/12/2025','01',:P1,:P2);
EXEC APATQP04.APATQP04_000('4VA15327862','A-000000000/2000','02','01/12/2025','01',:P1,:P2);

*/

BEGIN

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

/* NUMERO PROCESSO QUIPUX

Obrigatorio
Est  composto por:

Advertencia:
Inicial da area/dependencia responsavel PAE (A)
Sequencial atribu do pelo sistema
Ano corrente
Exemplo: A-000000000/2000

Defesa:
Inicial da area/dependencia responsavel CDA (D)
Sequencial atribuido pelo sistema
Ano corrente
Exemplo: D-000000000/2000

Indicacao de condutor
Inicial do servico solicitado
Sequencial atribuido pelo sistema
Ano corrente
Exemplo: I-000000000/2000

JARI
Numero que identifica recurso JARI (01)
Inicial da dependencia JARI
Sequencial atribuido pelo sistema
Ano corrente
Exemplo: 01-J0000000/2025

CETRAN
Numero que identifica a dependencia CETRAN (02)
Inicial da dependencia CETRAN
Sequencial atribuido pelo sistema
Ano corrente
Exemplo: 02-C0000000/2025

*/

IF P_NUMPROC IS NULL  THEN
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
--05 Indicacao de condutor

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

-- DEFESA DEVE SER TIPO SERVICO = 01 E NUM PROCESSO COMECAR COM 'D-'

IF P_TIPOSERV = '01' AND
   SUBSTR(P_NUMPROC,1,2) <> 'D-'  THEN

    P_COD_RETORNO := 1;
    P_MENSAGEM := 'Tipo de servico Defesa X numero processo invalido';
    GOTO SAIDA;

END IF;

-- advertencia DEVE SER TIPO SERVICO = 02 E NUM PROCESSO COMECAR COM 'A-'

IF P_TIPOSERV = '02' AND
   SUBSTR(P_NUMPROC,1,2) <> 'A-'  THEN

    P_COD_RETORNO := 1;
    P_MENSAGEM := 'Tipo de servico Advertencia X numero processo invalido';
    GOTO SAIDA;

END IF;

-- RECURSO JARI DEVE SER TIPO SERVICO = 03 E NUM PROCESSO COMECAR COM '01-J'

IF P_TIPOSERV = '03' AND
   SUBSTR(P_NUMPROC,1,4) <> '01-J'  THEN

    P_COD_RETORNO := 1;
    P_MENSAGEM := 'Tipo de servico Recurso Jari X numero processo invalido';
    GOTO SAIDA;

END IF;

-- RECURSO CETRAN DEVE SER TIPO SERVICO = 01 E NUM PROCESSO COMECAR COM '02-C'

IF P_TIPOSERV = '04' AND
   SUBSTR(P_NUMPROC,1,4) <> '02-C'  THEN

    P_COD_RETORNO := 1;
    P_MENSAGEM := 'Tipo de servico Recurso Cetran X numero processo invalido';
    GOTO SAIDA;

END IF;


-- DATA DE SOLICITACAO

IF P_DATASOLICITACAO  IS NULL  THEN
    P_COD_RETORNO := 2;
    P_MENSAGEM := 'Data de Solicitacao invalida';
    GOTO SAIDA;

END IF;

-- DATA  VALIDA

IF is_valid_date(P_DATASOLICITACAO, 'DD/MM/YYYY') = 0 THEN

--  'Data Invalida'

    P_COD_RETORNO := 2;
    P_MENSAGEM := 'Data de Solicitacao invalida';
    GOTO SAIDA;

END IF;

W_DT_SOLIC := TO_DATE(P_DATASOLICITACAO,'DD/MM/YYYY');

 IF TRUNC(W_DT_SOLIC) > TRUNC(SYSDATE) THEN
     P_MENSAGEM := 'Data de Solicitacao deve ser menor ou igual a data do dia';
       P_COD_RETORNO := 3;
       GOTO SAIDA;
  END IF;

-- PLATAFORMA ORIGEM

IF P_PLATAFORMA NOT IN ('01','02') THEN
     P_MENSAGEM := 'Plataforma Origem deve ser 01 ou 02';
       P_COD_RETORNO := 4;
       GOTO SAIDA;
  END IF;

-- 	CONSISTE SE NUMERO PROCESSO JA APONTA PARA OUTRO AIT NA TABELA T11059

 BEGIN

SELECT
           cod_grup_atdr || cod_ser_aiip || LPAD(cod_nro_aiip,6,'0')
||  udacaiip(COD_GRUP_ATDR,COD_SER_AIIP,COD_NRO_AIIP),
COD_ORG_JLGD||ANO_REC||COD_NRO_REC||ANO_DEFS_PRV||COD_NRO_DEFS_PRV
  INTO  W_NRO_AIT,
            W_NRO_PROCESSO
FROM  T11059_PCS_SRV_DGT
WHERE
           COD_PCSS_SERV_DIGT = P_NUMPROC AND
ROWNUM <2;

-- ERRO

IF W_NRO_AIT <> P_NUMAUTO THEN
    P_COD_RETORNO := 1;
    P_MENSAGEM := 'NÃºmero do processo '||P_NUMPROC ||' jÃ¡ cadastrado para outro Auto de infracao '||W_NRO_AIT;
    GOTO SAIDA;
END IF;

-- JA CADASTROU O MESMO PROCESSO E AIT

IF W_NRO_AIT = P_NUMAUTO THEN

    dbms_output.put_line('processo ja estava cadastrado ok   '||W_NRO_PROCESSO);
    P_COD_RETORNO := 1;
    P_MENSAGEM := 'NÃºmero do processo '||P_NUMPROC ||' jÃ¡ foi cadastrado anteriormente ';

    GOTO SAIDA;

END IF;


EXCEPTION
WHEN NO_DATA_FOUND THEN NULL;
END;


-- DIRECIONA PARA TRATAMENTO ESPECIFICO

IF P_TIPOSERV = '01' THEN -- DEFESA

dbms_output.put_line('CHAMA APATQP06');
    APATQP06.APATQP06_000(P_NUMAUTO,
                                                P_NUMPROC,
                                                W_DT_SOLIC,
                                                P_PLATAFORMA,
                                                P_COD_RETORNO,
                                                P_MENSAGEM );
    GOTO SAIDA;
END IF;

IF P_TIPOSERV = '02' THEN -- SOLICITACAO DE ADVERTENCIA

dbms_output.put_line('CHAMA APATQP07');

    APATQP07.APATQP07_000(P_NUMAUTO,
                                                P_NUMPROC,
                                                W_DT_SOLIC,
                                                P_PLATAFORMA,
                                                P_COD_RETORNO,
                                                P_MENSAGEM );
    GOTO SAIDA;
END IF;

IF P_TIPOSERV = '03' THEN -- RECURSO JARI

dbms_output.put_line('CHAMA APATQP08');

    APATQP08.APATQP08_000(P_NUMAUTO,
                                                P_NUMPROC,
                                                W_DT_SOLIC,
                                                P_PLATAFORMA,
                                                P_COD_RETORNO,
                                                P_MENSAGEM );
    GOTO SAIDA;
END IF;

IF P_TIPOSERV = '04' THEN -- RECURSO CETRAN

dbms_output.put_line('CHAMA APATQP09');

    APATQP09.APATQP09_000(P_NUMAUTO,
                                                P_NUMPROC,
                                                W_DT_SOLIC,
                                                P_PLATAFORMA,
                                                P_COD_RETORNO,
                                                P_MENSAGEM );
    GOTO SAIDA;
END IF;


EXCEPTION

  WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20201,'APATQP04_000- item '|| ' erro '||SQLERRM);
      ROLLBACK;

END;


<<SAIDA>>

IF P_COD_RETORNO IS NOT NULL THEN
    P_COD_RETORNO := P_COD_RETORNO + 400;
END IF;


END;




END APATQP04;

/
