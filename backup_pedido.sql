PGDMP         *                 {            pedido    15.1    15.1 �    (           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            )           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            *           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            +           1262    24644    pedido    DATABASE     r   CREATE DATABASE pedido WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'pt_BR.UTF-8';
    DROP DATABASE pedido;
                postgres    false            �           1247    57653    codigo    DOMAIN     6   CREATE DOMAIN public.codigo AS character varying(10);
    DROP DOMAIN public.codigo;
       public          postgres    false            �           1247    57661    data    DOMAIN     #   CREATE DOMAIN public.data AS date;
    DROP DOMAIN public.data;
       public          postgres    false            �           1247    57665 	   data_hora    DOMAIN     ?   CREATE DOMAIN public.data_hora AS timestamp without time zone;
    DROP DOMAIN public.data_hora;
       public          postgres    false            �           1247    57679 	   documento    DOMAIN     9   CREATE DOMAIN public.documento AS character varying(15);
    DROP DOMAIN public.documento;
       public          postgres    false            �           1247    57669    float_curto    DOMAIN     2   CREATE DOMAIN public.float_curto AS numeric(6,2);
     DROP DOMAIN public.float_curto;
       public          postgres    false            �           1247    57673    float_longo    DOMAIN     3   CREATE DOMAIN public.float_longo AS numeric(15,2);
     DROP DOMAIN public.float_longo;
       public          postgres    false            �           1247    57671    float_medio    DOMAIN     3   CREATE DOMAIN public.float_medio AS numeric(10,2);
     DROP DOMAIN public.float_medio;
       public          postgres    false            �           1247    57663    hora    DOMAIN     5   CREATE DOMAIN public.hora AS time without time zone;
    DROP DOMAIN public.hora;
       public          postgres    false            �           1247    57645    idcurto    DOMAIN     *   CREATE DOMAIN public.idcurto AS smallint;
    DROP DOMAIN public.idcurto;
       public          postgres    false            �           1247    57649    idlongo    DOMAIN     (   CREATE DOMAIN public.idlongo AS bigint;
    DROP DOMAIN public.idlongo;
       public          postgres    false            �           1247    57647    idmedio    DOMAIN     )   CREATE DOMAIN public.idmedio AS integer;
    DROP DOMAIN public.idmedio;
       public          postgres    false            �           1247    57667    moeda    DOMAIN     -   CREATE DOMAIN public.moeda AS numeric(10,2);
    DROP DOMAIN public.moeda;
       public          postgres    false            �           1247    57655 
   nome_curto    DOMAIN     :   CREATE DOMAIN public.nome_curto AS character varying(15);
    DROP DOMAIN public.nome_curto;
       public          postgres    false            �           1247    57659 
   nome_longo    DOMAIN     :   CREATE DOMAIN public.nome_longo AS character varying(70);
    DROP DOMAIN public.nome_longo;
       public          postgres    false            �           1247    57657 
   nome_medio    DOMAIN     :   CREATE DOMAIN public.nome_medio AS character varying(50);
    DROP DOMAIN public.nome_medio;
       public          postgres    false            �           1247    57685 
   quantidade    DOMAIN     -   CREATE DOMAIN public.quantidade AS smallint;
    DROP DOMAIN public.quantidade;
       public          postgres    false            �           1247    57651    sigla    DOMAIN     ,   CREATE DOMAIN public.sigla AS character(3);
    DROP DOMAIN public.sigla;
       public          postgres    false            �           1247    57683    texto    DOMAIN     $   CREATE DOMAIN public.texto AS text;
    DROP DOMAIN public.texto;
       public          postgres    false            �           1247    57681    tipo    DOMAIN     +   CREATE DOMAIN public.tipo AS character(1);
    DROP DOMAIN public.tipo;
       public          postgres    false                       1255    57630    apagar_produto(integer) 	   PROCEDURE     �   CREATE PROCEDURE public.apagar_produto(IN idp integer)
    LANGUAGE sql
    AS $$
	delete from produto where idproduto = idp;
$$;
 6   DROP PROCEDURE public.apagar_produto(IN idp integer);
       public          postgres    false                       1255    57634    bairro_log()    FUNCTION     �   CREATE FUNCTION public.bairro_log() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	-- old 4 -> new 6
	insert into bairro_auditoria (idbairro, data_criacao) values (new.idbairro, current_timestamp);
	return new;
end;
$$;
 #   DROP FUNCTION public.bairro_log();
       public          postgres    false            �            1255    57616    formata_moeda(double precision)    FUNCTION     �   CREATE FUNCTION public.formata_moeda(valor double precision) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
begin
	return concat('R$ ', round(cast(valor as numeric), 2));
end;
$_$;
 <   DROP FUNCTION public.formata_moeda(valor double precision);
       public          postgres    false            �            1255    57626    get_maior_pedido()    FUNCTION     �   CREATE FUNCTION public.get_maior_pedido() RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	return (select idpedido from pedido where valor = (select max(valor) from pedido));
end;
$$;
 )   DROP FUNCTION public.get_maior_pedido();
       public          postgres    false            �            1255    57627    get_nome_by_id(integer)    FUNCTION     �   CREATE FUNCTION public.get_nome_by_id(idc integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
declare r varchar(50);
begin
	select nome into r from cliente where idcliente = idc;
	return r;
end;
$$;
 2   DROP FUNCTION public.get_nome_by_id(idc integer);
       public          postgres    false            �            1255    57623    get_valor_pedido(integer)    FUNCTION     �   CREATE FUNCTION public.get_valor_pedido(idpdd integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
begin
	return (select formata_moeda(pdd.valor) from pedido pdd where pdd.idpedido = idpdd);
end;
$$;
 6   DROP FUNCTION public.get_valor_pedido(idpdd integer);
       public          postgres    false                        1255    57628     insere_bairro(character varying) 	   PROCEDURE     �   CREATE PROCEDURE public.insere_bairro(IN nome_bairro character varying)
    LANGUAGE sql
    AS $$
	insert into bairro (nome) values (nome_bairro);
$$;
 G   DROP PROCEDURE public.insere_bairro(IN nome_bairro character varying);
       public          postgres    false                       1255    57639    pedido_log()    FUNCTION     _  CREATE FUNCTION public.pedido_log() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	insert into pedidos_apagados (idpedido, idcliente, idtransportadora, idvendedor, data_pedido, valor, data_apagado)
	values (old.idpedido, old.idcliente, old.idtransportadora, old.idvendedor, old.data_pedido, old.valor, current_timestamp);
	return old;
end;
$$;
 #   DROP FUNCTION public.pedido_log();
       public          postgres    false                       1255    57629 +   reajusta_produto(integer, double precision) 	   PROCEDURE     �   CREATE PROCEDURE public.reajusta_produto(IN idp integer, IN percentual double precision)
    LANGUAGE sql
    AS $$
	update produto set valor = valor + ((valor * percentual) / 100) where idproduto = idp;
$$;
 X   DROP PROCEDURE public.reajusta_produto(IN idp integer, IN percentual double precision);
       public          postgres    false            �            1259    32857    bairro    TABLE     c   CREATE TABLE public.bairro (
    idbairro integer NOT NULL,
    nome public.nome_medio NOT NULL
);
    DROP TABLE public.bairro;
       public         heap    postgres    false    949            ,           0    0    TABLE bairro    ACL     W   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.bairro TO gerente WITH GRANT OPTION;
          public          postgres    false    218            �            1259    57631    bairro_auditoria    TABLE     t   CREATE TABLE public.bairro_auditoria (
    idbairro integer NOT NULL,
    data_criacao public.data_hora NOT NULL
);
 $   DROP TABLE public.bairro_auditoria;
       public         heap    postgres    false    961            �            1259    49311    bairro_id_seq    SEQUENCE     u   CREATE SEQUENCE public.bairro_id_seq
    START WITH 5
    INCREMENT BY 1
    MINVALUE 5
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.bairro_id_seq;
       public          postgres    false    218            -           0    0    bairro_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.bairro_id_seq OWNED BY public.bairro.idbairro;
          public          postgres    false    229            .           0    0    SEQUENCE bairro_id_seq    ACL     7   GRANT ALL ON SEQUENCE public.bairro_id_seq TO gerente;
          public          postgres    false    229            �            1259    24645    cliente    TABLE     �  CREATE TABLE public.cliente (
    idcliente integer NOT NULL,
    nome public.nome_longo NOT NULL,
    cpf public.documento,
    rg public.documento,
    data_nascimento public.data,
    genero public.tipo,
    logradouro public.nome_longo,
    numero public.nome_curto,
    observacoes text,
    idprofissao public.idmedio,
    idnacionalidade public.idmedio,
    idcomplemento public.idmedio,
    idbairro public.idmedio,
    idmunicipio public.idmedio
);
    DROP TABLE public.cliente;
       public         heap    postgres    false    934    934    976    955    952    976    934    946    979    952    934    934            /           0    0    TABLE cliente    ACL     X   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cliente TO gerente WITH GRANT OPTION;
          public          postgres    false    214            �            1259    32850    complemento    TABLE     m   CREATE TABLE public.complemento (
    idcomplemento integer NOT NULL,
    nome public.nome_medio NOT NULL
);
    DROP TABLE public.complemento;
       public         heap    postgres    false    949            0           0    0    TABLE complemento    ACL     \   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.complemento TO gerente WITH GRANT OPTION;
          public          postgres    false    217            �            1259    41037 	   municipio    TABLE     �   CREATE TABLE public.municipio (
    idmunicipio integer NOT NULL,
    nome public.nome_medio NOT NULL,
    iduf public.idmedio NOT NULL
);
    DROP TABLE public.municipio;
       public         heap    postgres    false    934    949            1           0    0    TABLE municipio    ACL     Z   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.municipio TO gerente WITH GRANT OPTION;
          public          postgres    false    220            �            1259    32843    nacionalidade    TABLE     q   CREATE TABLE public.nacionalidade (
    idnacionalidade integer NOT NULL,
    nome public.nome_medio NOT NULL
);
 !   DROP TABLE public.nacionalidade;
       public         heap    postgres    false    949            2           0    0    TABLE nacionalidade    ACL     ^   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.nacionalidade TO gerente WITH GRANT OPTION;
          public          postgres    false    216            �            1259    32836 	   profissao    TABLE     i   CREATE TABLE public.profissao (
    idprofissao integer NOT NULL,
    nome public.nome_medio NOT NULL
);
    DROP TABLE public.profissao;
       public         heap    postgres    false    949            3           0    0    TABLE profissao    ACL     Z   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.profissao TO gerente WITH GRANT OPTION;
          public          postgres    false    215            �            1259    41028    uf    TABLE     |   CREATE TABLE public.uf (
    iduf integer NOT NULL,
    nome public.nome_medio NOT NULL,
    sigla public.sigla NOT NULL
);
    DROP TABLE public.uf;
       public         heap    postgres    false    940    949            4           0    0    TABLE uf    ACL     S   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.uf TO gerente WITH GRANT OPTION;
          public          postgres    false    219            �            1259    57889    cliente_dados    VIEW     0  CREATE VIEW public.cliente_dados AS
 SELECT cln.nome AS cliente,
    prf.nome AS profissao,
    ncn.nome AS nacionalidade,
    cmp.nome AS complemento,
    mnc.nome AS municipio,
    uf.nome AS unidade_federacao,
    brr.nome AS bairro,
    cln.rg,
    cln.cpf,
    cln.data_nascimento,
        CASE cln.genero
            WHEN 'M'::bpchar THEN 'Masculino'::text
            WHEN 'F'::bpchar THEN 'Feminimo'::text
            ELSE NULL::text
        END AS genero,
    cln.logradouro,
    cln.numero,
    cln.observacoes
   FROM ((((((public.cliente cln
     LEFT JOIN public.profissao prf ON (((cln.idprofissao)::integer = prf.idprofissao)))
     LEFT JOIN public.nacionalidade ncn ON (((cln.idnacionalidade)::integer = ncn.idnacionalidade)))
     LEFT JOIN public.complemento cmp ON (((cln.idcomplemento)::integer = cmp.idcomplemento)))
     LEFT JOIN public.municipio mnc ON (((cln.idmunicipio)::integer = mnc.idmunicipio)))
     LEFT JOIN public.uf ON (((mnc.iduf)::integer = uf.iduf)))
     LEFT JOIN public.bairro brr ON (((cln.idbairro)::integer = brr.idbairro)));
     DROP VIEW public.cliente_dados;
       public          postgres    false    214    218    218    219    219    220    220    220    214    214    214    214    214    214    214    214    214    214    214    217    214    215    215    216    216    217    952    949    949    949    949    949    949    976    976    955    952    946            5           0    0    TABLE cliente_dados    ACL     :   GRANT SELECT ON TABLE public.cliente_dados TO estagiario;
          public          postgres    false    244            �            1259    49313    cliente_id_seq    SEQUENCE     x   CREATE SEQUENCE public.cliente_id_seq
    START WITH 18
    INCREMENT BY 1
    MINVALUE 18
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.cliente_id_seq;
       public          postgres    false    214            6           0    0    cliente_id_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.cliente_id_seq OWNED BY public.cliente.idcliente;
          public          postgres    false    230            7           0    0    SEQUENCE cliente_id_seq    ACL     8   GRANT ALL ON SEQUENCE public.cliente_id_seq TO gerente;
          public          postgres    false    230            �            1259    57885    cliente_profissao    VIEW     �   CREATE VIEW public.cliente_profissao AS
 SELECT cln.nome AS cliente,
    cln.cpf,
    prf.nome AS profissao
   FROM (public.cliente cln
     LEFT JOIN public.profissao prf ON (((cln.idprofissao)::integer = prf.idprofissao)));
 $   DROP VIEW public.cliente_profissao;
       public          postgres    false    214    214    215    215    214    952    976    949            �            1259    49315    complemento_id_seq    SEQUENCE     z   CREATE SEQUENCE public.complemento_id_seq
    START WITH 3
    INCREMENT BY 1
    MINVALUE 3
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.complemento_id_seq;
       public          postgres    false    217            8           0    0    complemento_id_seq    SEQUENCE OWNED BY     T   ALTER SEQUENCE public.complemento_id_seq OWNED BY public.complemento.idcomplemento;
          public          postgres    false    231            9           0    0    SEQUENCE complemento_id_seq    ACL     <   GRANT ALL ON SEQUENCE public.complemento_id_seq TO gerente;
          public          postgres    false    231            �            1259    66061    conta    TABLE     �   CREATE TABLE public.conta (
    idconta integer NOT NULL,
    cliente public.nome_medio NOT NULL,
    saldo public.moeda DEFAULT 0 NOT NULL
);
    DROP TABLE public.conta;
       public         heap    postgres    false    964    964    949            �            1259    66060    conta_idconta_seq    SEQUENCE     �   CREATE SEQUENCE public.conta_idconta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.conta_idconta_seq;
       public          postgres    false    251            :           0    0    conta_idconta_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.conta_idconta_seq OWNED BY public.conta.idconta;
          public          postgres    false    250            �            1259    41090    pedido    TABLE       CREATE TABLE public.pedido (
    idpedido bigint NOT NULL,
    idcliente public.idmedio NOT NULL,
    idtransportadora public.idmedio,
    idvendedor public.idmedio NOT NULL,
    data_pedido public.data DEFAULT CURRENT_DATE NOT NULL,
    valor public.moeda DEFAULT 0 NOT NULL
);
    DROP TABLE public.pedido;
       public         heap    postgres    false    955    964    934    934    934    964    955            ;           0    0    TABLE pedido    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.pedido TO gerente WITH GRANT OPTION;
GRANT SELECT,INSERT ON TABLE public.pedido TO atendente WITH GRANT OPTION;
          public          postgres    false    225            �            1259    41068    transportadora    TABLE     �   CREATE TABLE public.transportadora (
    idtransportadora integer NOT NULL,
    idmunicipio public.idmedio,
    nome public.nome_medio NOT NULL,
    logradouro public.nome_longo,
    numero public.nome_curto
);
 "   DROP TABLE public.transportadora;
       public         heap    postgres    false    949    946    952    934            <           0    0    TABLE transportadora    ACL     _   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.transportadora TO gerente WITH GRANT OPTION;
          public          postgres    false    223            �            1259    41061    vendedor    TABLE     g   CREATE TABLE public.vendedor (
    idvendedor integer NOT NULL,
    nome public.nome_medio NOT NULL
);
    DROP TABLE public.vendedor;
       public         heap    postgres    false    949            =           0    0    TABLE vendedor    ACL     Y   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.vendedor TO gerente WITH GRANT OPTION;
          public          postgres    false    222            �            1259    57906    dados_pedido    VIEW     �  CREATE VIEW public.dados_pedido AS
 SELECT pdd.data_pedido,
    pdd.valor,
    trn.nome AS transportadora,
    cln.nome AS cliente,
    vnd.nome AS vendedor
   FROM (((public.pedido pdd
     LEFT JOIN public.transportadora trn ON (((pdd.idtransportadora)::integer = trn.idtransportadora)))
     LEFT JOIN public.cliente cln ON (((pdd.idcliente)::integer = cln.idcliente)))
     LEFT JOIN public.vendedor vnd ON (((pdd.idvendedor)::integer = vnd.idvendedor)));
    DROP VIEW public.dados_pedido;
       public          postgres    false    225    225    225    225    223    223    222    222    214    214    225    949    949    952    964    955            >           0    0    TABLE dados_pedido    ACL     9   GRANT SELECT ON TABLE public.dados_pedido TO estagiario;
          public          postgres    false    248            �            1259    49305    exemplo    TABLE     i   CREATE TABLE public.exemplo (
    idexemplo integer NOT NULL,
    nome character varying(50) NOT NULL
);
    DROP TABLE public.exemplo;
       public         heap    postgres    false            �            1259    49304    exemplo_idexemplo_seq    SEQUENCE     �   CREATE SEQUENCE public.exemplo_idexemplo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.exemplo_idexemplo_seq;
       public          postgres    false    228            ?           0    0    exemplo_idexemplo_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.exemplo_idexemplo_seq OWNED BY public.exemplo.idexemplo;
          public          postgres    false    227            @           0    0    SEQUENCE exemplo_idexemplo_seq    ACL     ?   GRANT ALL ON SEQUENCE public.exemplo_idexemplo_seq TO gerente;
          public          postgres    false    227            �            1259    41054 
   fornecedor    TABLE     k   CREATE TABLE public.fornecedor (
    idfornecedor integer NOT NULL,
    nome public.nome_medio NOT NULL
);
    DROP TABLE public.fornecedor;
       public         heap    postgres    false    949            A           0    0    TABLE fornecedor    ACL     [   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.fornecedor TO gerente WITH GRANT OPTION;
          public          postgres    false    221            �            1259    49317    fornecedor_id_seq    SEQUENCE     y   CREATE SEQUENCE public.fornecedor_id_seq
    START WITH 4
    INCREMENT BY 1
    MINVALUE 4
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.fornecedor_id_seq;
       public          postgres    false    221            B           0    0    fornecedor_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.fornecedor_id_seq OWNED BY public.fornecedor.idfornecedor;
          public          postgres    false    232            C           0    0    SEQUENCE fornecedor_id_seq    ACL     ;   GRANT ALL ON SEQUENCE public.fornecedor_id_seq TO gerente;
          public          postgres    false    232            �            1259    49319    municipio_id_seq    SEQUENCE     z   CREATE SEQUENCE public.municipio_id_seq
    START WITH 10
    INCREMENT BY 1
    MINVALUE 10
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.municipio_id_seq;
       public          postgres    false    220            D           0    0    municipio_id_seq    SEQUENCE OWNED BY     N   ALTER SEQUENCE public.municipio_id_seq OWNED BY public.municipio.idmunicipio;
          public          postgres    false    233            E           0    0    SEQUENCE municipio_id_seq    ACL     :   GRANT ALL ON SEQUENCE public.municipio_id_seq TO gerente;
          public          postgres    false    233            �            1259    57894    municipio_uf    VIEW     �   CREATE VIEW public.municipio_uf AS
 SELECT mnc.nome AS municipio,
    uf.nome AS unidade_federacao,
    uf.sigla
   FROM (public.municipio mnc
     LEFT JOIN public.uf ON (((mnc.iduf)::integer = uf.iduf)));
    DROP VIEW public.municipio_uf;
       public          postgres    false    219    220    219    219    220    940    949    949            �            1259    49321    nacionalidade_id_seq    SEQUENCE     |   CREATE SEQUENCE public.nacionalidade_id_seq
    START WITH 5
    INCREMENT BY 1
    MINVALUE 5
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.nacionalidade_id_seq;
       public          postgres    false    216            F           0    0    nacionalidade_id_seq    SEQUENCE OWNED BY     Z   ALTER SEQUENCE public.nacionalidade_id_seq OWNED BY public.nacionalidade.idnacionalidade;
          public          postgres    false    234            G           0    0    SEQUENCE nacionalidade_id_seq    ACL     >   GRANT ALL ON SEQUENCE public.nacionalidade_id_seq TO gerente;
          public          postgres    false    234            �            1259    49323    pedido_id_seq    SEQUENCE     w   CREATE SEQUENCE public.pedido_id_seq
    START WITH 16
    INCREMENT BY 1
    MINVALUE 16
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.pedido_id_seq;
       public          postgres    false    225            H           0    0    pedido_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.pedido_id_seq OWNED BY public.pedido.idpedido;
          public          postgres    false    235            I           0    0    SEQUENCE pedido_id_seq    ACL     �   GRANT ALL ON SEQUENCE public.pedido_id_seq TO gerente;
GRANT ALL ON SEQUENCE public.pedido_id_seq TO atendente WITH GRANT OPTION;
          public          postgres    false    235            �            1259    41110    pedido_produto    TABLE     �   CREATE TABLE public.pedido_produto (
    idpedido public.idlongo NOT NULL,
    idproduto public.idmedio NOT NULL,
    quantidade public.quantidade DEFAULT 1 NOT NULL,
    valor_unitario public.moeda DEFAULT 0 NOT NULL
);
 "   DROP TABLE public.pedido_produto;
       public         heap    postgres    false    985    964    937    934    985    964            J           0    0    TABLE pedido_produto    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.pedido_produto TO gerente WITH GRANT OPTION;
GRANT SELECT,INSERT ON TABLE public.pedido_produto TO atendente WITH GRANT OPTION;
          public          postgres    false    226            �            1259    57636    pedidos_apagados    TABLE     A  CREATE TABLE public.pedidos_apagados (
    idpedido public.idlongo NOT NULL,
    idcliente public.idmedio NOT NULL,
    idtransportadora public.idmedio,
    idvendedor public.idmedio NOT NULL,
    data_pedido public.data NOT NULL,
    valor public.moeda NOT NULL,
    data_apagado timestamp without time zone NOT NULL
);
 $   DROP TABLE public.pedidos_apagados;
       public         heap    postgres    false    934    934    937    955    934    964            �            1259    41080    produto    TABLE     �   CREATE TABLE public.produto (
    idproduto integer NOT NULL,
    idfornecedor public.idmedio NOT NULL,
    nome public.nome_medio NOT NULL,
    valor public.moeda DEFAULT 0 NOT NULL
);
    DROP TABLE public.produto;
       public         heap    postgres    false    964    964    949    934            K           0    0    TABLE produto    ACL     X   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.produto TO gerente WITH GRANT OPTION;
          public          postgres    false    224            �            1259    57898    produto_fornecedor    VIEW     �   CREATE VIEW public.produto_fornecedor AS
 SELECT prd.nome AS produto,
    prd.valor,
    frn.nome AS fornecedor
   FROM (public.produto prd
     LEFT JOIN public.fornecedor frn ON (((prd.idfornecedor)::integer = frn.idfornecedor)));
 %   DROP VIEW public.produto_fornecedor;
       public          postgres    false    224    224    224    221    221    964    949    949            �            1259    49338    produto_id_seq    SEQUENCE     v   CREATE SEQUENCE public.produto_id_seq
    START WITH 8
    INCREMENT BY 1
    MINVALUE 8
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.produto_id_seq;
       public          postgres    false    224            L           0    0    produto_id_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.produto_id_seq OWNED BY public.produto.idproduto;
          public          postgres    false    240            M           0    0    SEQUENCE produto_id_seq    ACL     8   GRANT ALL ON SEQUENCE public.produto_id_seq TO gerente;
          public          postgres    false    240            �            1259    57911    produto_pedido    VIEW     �   CREATE VIEW public.produto_pedido AS
 SELECT prd.nome AS produto,
    pdp.quantidade,
    pdp.valor_unitario
   FROM (public.pedido_produto pdp
     LEFT JOIN public.produto prd ON (((pdp.idproduto)::integer = prd.idproduto)));
 !   DROP VIEW public.produto_pedido;
       public          postgres    false    224    226    224    226    226    949    985    964            �            1259    49325    profissao_id_seq    SEQUENCE     x   CREATE SEQUENCE public.profissao_id_seq
    START WITH 6
    INCREMENT BY 1
    MINVALUE 6
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.profissao_id_seq;
       public          postgres    false    215            N           0    0    profissao_id_seq    SEQUENCE OWNED BY     N   ALTER SEQUENCE public.profissao_id_seq OWNED BY public.profissao.idprofissao;
          public          postgres    false    236            O           0    0    SEQUENCE profissao_id_seq    ACL     :   GRANT ALL ON SEQUENCE public.profissao_id_seq TO gerente;
          public          postgres    false    236            �            1259    49327    transportadora_id_seq    SEQUENCE     }   CREATE SEQUENCE public.transportadora_id_seq
    START WITH 3
    INCREMENT BY 1
    MINVALUE 3
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.transportadora_id_seq;
       public          postgres    false    223            P           0    0    transportadora_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.transportadora_id_seq OWNED BY public.transportadora.idtransportadora;
          public          postgres    false    237            Q           0    0    SEQUENCE transportadora_id_seq    ACL     ?   GRANT ALL ON SEQUENCE public.transportadora_id_seq TO gerente;
          public          postgres    false    237            �            1259    57902    transportadora_uf    VIEW     \  CREATE VIEW public.transportadora_uf AS
 SELECT trn.nome AS transportadora,
    trn.logradouro,
    trn.numero,
    uf.nome AS unidade_federacao,
    uf.sigla
   FROM ((public.transportadora trn
     LEFT JOIN public.municipio mnc ON (((trn.idmunicipio)::integer = mnc.idmunicipio)))
     LEFT JOIN public.uf ON (((mnc.iduf)::integer = uf.iduf)));
 $   DROP VIEW public.transportadora_uf;
       public          postgres    false    223    220    223    223    223    219    220    219    219    946    952    949    949    940            �            1259    49329 	   uf_id_seq    SEQUENCE     q   CREATE SEQUENCE public.uf_id_seq
    START WITH 7
    INCREMENT BY 1
    MINVALUE 7
    NO MAXVALUE
    CACHE 1;
     DROP SEQUENCE public.uf_id_seq;
       public          postgres    false    219            R           0    0 	   uf_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE public.uf_id_seq OWNED BY public.uf.iduf;
          public          postgres    false    238            S           0    0    SEQUENCE uf_id_seq    ACL     3   GRANT ALL ON SEQUENCE public.uf_id_seq TO gerente;
          public          postgres    false    238            �            1259    49331    vendedor_id_seq    SEQUENCE     w   CREATE SEQUENCE public.vendedor_id_seq
    START WITH 9
    INCREMENT BY 1
    MINVALUE 9
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.vendedor_id_seq;
       public          postgres    false    222            T           0    0    vendedor_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.vendedor_id_seq OWNED BY public.vendedor.idvendedor;
          public          postgres    false    239            U           0    0    SEQUENCE vendedor_id_seq    ACL     9   GRANT ALL ON SEQUENCE public.vendedor_id_seq TO gerente;
          public          postgres    false    239                       2604    49312    bairro idbairro    DEFAULT     l   ALTER TABLE ONLY public.bairro ALTER COLUMN idbairro SET DEFAULT nextval('public.bairro_id_seq'::regclass);
 >   ALTER TABLE public.bairro ALTER COLUMN idbairro DROP DEFAULT;
       public          postgres    false    229    218                       2604    49314    cliente idcliente    DEFAULT     o   ALTER TABLE ONLY public.cliente ALTER COLUMN idcliente SET DEFAULT nextval('public.cliente_id_seq'::regclass);
 @   ALTER TABLE public.cliente ALTER COLUMN idcliente DROP DEFAULT;
       public          postgres    false    230    214                       2604    49316    complemento idcomplemento    DEFAULT     {   ALTER TABLE ONLY public.complemento ALTER COLUMN idcomplemento SET DEFAULT nextval('public.complemento_id_seq'::regclass);
 H   ALTER TABLE public.complemento ALTER COLUMN idcomplemento DROP DEFAULT;
       public          postgres    false    231    217            ,           2604    66064    conta idconta    DEFAULT     n   ALTER TABLE ONLY public.conta ALTER COLUMN idconta SET DEFAULT nextval('public.conta_idconta_seq'::regclass);
 <   ALTER TABLE public.conta ALTER COLUMN idconta DROP DEFAULT;
       public          postgres    false    250    251    251            +           2604    49308    exemplo idexemplo    DEFAULT     v   ALTER TABLE ONLY public.exemplo ALTER COLUMN idexemplo SET DEFAULT nextval('public.exemplo_idexemplo_seq'::regclass);
 @   ALTER TABLE public.exemplo ALTER COLUMN idexemplo DROP DEFAULT;
       public          postgres    false    228    227    228            !           2604    49318    fornecedor idfornecedor    DEFAULT     x   ALTER TABLE ONLY public.fornecedor ALTER COLUMN idfornecedor SET DEFAULT nextval('public.fornecedor_id_seq'::regclass);
 F   ALTER TABLE public.fornecedor ALTER COLUMN idfornecedor DROP DEFAULT;
       public          postgres    false    232    221                        2604    49320    municipio idmunicipio    DEFAULT     u   ALTER TABLE ONLY public.municipio ALTER COLUMN idmunicipio SET DEFAULT nextval('public.municipio_id_seq'::regclass);
 D   ALTER TABLE public.municipio ALTER COLUMN idmunicipio DROP DEFAULT;
       public          postgres    false    233    220                       2604    49322    nacionalidade idnacionalidade    DEFAULT     �   ALTER TABLE ONLY public.nacionalidade ALTER COLUMN idnacionalidade SET DEFAULT nextval('public.nacionalidade_id_seq'::regclass);
 L   ALTER TABLE public.nacionalidade ALTER COLUMN idnacionalidade DROP DEFAULT;
       public          postgres    false    234    216            &           2604    57744    pedido idpedido    DEFAULT     l   ALTER TABLE ONLY public.pedido ALTER COLUMN idpedido SET DEFAULT nextval('public.pedido_id_seq'::regclass);
 >   ALTER TABLE public.pedido ALTER COLUMN idpedido DROP DEFAULT;
       public          postgres    false    235    225            $           2604    49339    produto idproduto    DEFAULT     o   ALTER TABLE ONLY public.produto ALTER COLUMN idproduto SET DEFAULT nextval('public.produto_id_seq'::regclass);
 @   ALTER TABLE public.produto ALTER COLUMN idproduto DROP DEFAULT;
       public          postgres    false    240    224                       2604    49326    profissao idprofissao    DEFAULT     u   ALTER TABLE ONLY public.profissao ALTER COLUMN idprofissao SET DEFAULT nextval('public.profissao_id_seq'::regclass);
 D   ALTER TABLE public.profissao ALTER COLUMN idprofissao DROP DEFAULT;
       public          postgres    false    236    215            #           2604    49328    transportadora idtransportadora    DEFAULT     �   ALTER TABLE ONLY public.transportadora ALTER COLUMN idtransportadora SET DEFAULT nextval('public.transportadora_id_seq'::regclass);
 N   ALTER TABLE public.transportadora ALTER COLUMN idtransportadora DROP DEFAULT;
       public          postgres    false    237    223                       2604    49330    uf iduf    DEFAULT     `   ALTER TABLE ONLY public.uf ALTER COLUMN iduf SET DEFAULT nextval('public.uf_id_seq'::regclass);
 6   ALTER TABLE public.uf ALTER COLUMN iduf DROP DEFAULT;
       public          postgres    false    238    219            "           2604    49332    vendedor idvendedor    DEFAULT     r   ALTER TABLE ONLY public.vendedor ALTER COLUMN idvendedor SET DEFAULT nextval('public.vendedor_id_seq'::regclass);
 B   ALTER TABLE public.vendedor ALTER COLUMN idvendedor DROP DEFAULT;
       public          postgres    false    239    222                      0    32857    bairro 
   TABLE DATA           0   COPY public.bairro (idbairro, nome) FROM stdin;
    public          postgres    false    218   a�       "          0    57631    bairro_auditoria 
   TABLE DATA           B   COPY public.bairro_auditoria (idbairro, data_criacao) FROM stdin;
    public          postgres    false    241   ��                 0    24645    cliente 
   TABLE DATA           �   COPY public.cliente (idcliente, nome, cpf, rg, data_nascimento, genero, logradouro, numero, observacoes, idprofissao, idnacionalidade, idcomplemento, idbairro, idmunicipio) FROM stdin;
    public          postgres    false    214   �       
          0    32850    complemento 
   TABLE DATA           :   COPY public.complemento (idcomplemento, nome) FROM stdin;
    public          postgres    false    217   B�       %          0    66061    conta 
   TABLE DATA           8   COPY public.conta (idconta, cliente, saldo) FROM stdin;
    public          postgres    false    251   ��                 0    49305    exemplo 
   TABLE DATA           2   COPY public.exemplo (idexemplo, nome) FROM stdin;
    public          postgres    false    228   ��                 0    41054 
   fornecedor 
   TABLE DATA           8   COPY public.fornecedor (idfornecedor, nome) FROM stdin;
    public          postgres    false    221   ��                 0    41037 	   municipio 
   TABLE DATA           <   COPY public.municipio (idmunicipio, nome, iduf) FROM stdin;
    public          postgres    false    220   S�       	          0    32843    nacionalidade 
   TABLE DATA           >   COPY public.nacionalidade (idnacionalidade, nome) FROM stdin;
    public          postgres    false    216   ��                 0    41090    pedido 
   TABLE DATA           g   COPY public.pedido (idpedido, idcliente, idtransportadora, idvendedor, data_pedido, valor) FROM stdin;
    public          postgres    false    225   ]�                 0    41110    pedido_produto 
   TABLE DATA           Y   COPY public.pedido_produto (idpedido, idproduto, quantidade, valor_unitario) FROM stdin;
    public          postgres    false    226   2�       #          0    57636    pedidos_apagados 
   TABLE DATA              COPY public.pedidos_apagados (idpedido, idcliente, idtransportadora, idvendedor, data_pedido, valor, data_apagado) FROM stdin;
    public          postgres    false    242   ��                 0    41080    produto 
   TABLE DATA           G   COPY public.produto (idproduto, idfornecedor, nome, valor) FROM stdin;
    public          postgres    false    224   �                 0    32836 	   profissao 
   TABLE DATA           6   COPY public.profissao (idprofissao, nome) FROM stdin;
    public          postgres    false    215   ��                 0    41068    transportadora 
   TABLE DATA           a   COPY public.transportadora (idtransportadora, idmunicipio, nome, logradouro, numero) FROM stdin;
    public          postgres    false    223   �                 0    41028    uf 
   TABLE DATA           /   COPY public.uf (iduf, nome, sigla) FROM stdin;
    public          postgres    false    219   ��                 0    41061    vendedor 
   TABLE DATA           4   COPY public.vendedor (idvendedor, nome) FROM stdin;
    public          postgres    false    222   �       V           0    0    bairro_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.bairro_id_seq', 11, true);
          public          postgres    false    229            W           0    0    cliente_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.cliente_id_seq', 21, true);
          public          postgres    false    230            X           0    0    complemento_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.complemento_id_seq', 3, true);
          public          postgres    false    231            Y           0    0    conta_idconta_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.conta_idconta_seq', 2, true);
          public          postgres    false    250            Z           0    0    exemplo_idexemplo_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.exemplo_idexemplo_seq', 5, true);
          public          postgres    false    227            [           0    0    fornecedor_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.fornecedor_id_seq', 4, true);
          public          postgres    false    232            \           0    0    municipio_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.municipio_id_seq', 11, true);
          public          postgres    false    233            ]           0    0    nacionalidade_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.nacionalidade_id_seq', 5, true);
          public          postgres    false    234            ^           0    0    pedido_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.pedido_id_seq', 19, true);
          public          postgres    false    235            _           0    0    produto_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.produto_id_seq', 10, true);
          public          postgres    false    240            `           0    0    profissao_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.profissao_id_seq', 6, true);
          public          postgres    false    236            a           0    0    transportadora_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.transportadora_id_seq', 3, true);
          public          postgres    false    237            b           0    0 	   uf_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('public.uf_id_seq', 8, true);
          public          postgres    false    238            c           0    0    vendedor_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.vendedor_id_seq', 9, true);
          public          postgres    false    239            >           2606    32861    bairro pk_brr_idbairro 
   CONSTRAINT     Z   ALTER TABLE ONLY public.bairro
    ADD CONSTRAINT pk_brr_idbairro PRIMARY KEY (idbairro);
 @   ALTER TABLE ONLY public.bairro DROP CONSTRAINT pk_brr_idbairro;
       public            postgres    false    218            0           2606    24651    cliente pk_cln_idcliente 
   CONSTRAINT     ]   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT pk_cln_idcliente PRIMARY KEY (idcliente);
 B   ALTER TABLE ONLY public.cliente DROP CONSTRAINT pk_cln_idcliente;
       public            postgres    false    214            b           2606    66069    conta pk_cnt_idconta 
   CONSTRAINT     W   ALTER TABLE ONLY public.conta
    ADD CONSTRAINT pk_cnt_idconta PRIMARY KEY (idconta);
 >   ALTER TABLE ONLY public.conta DROP CONSTRAINT pk_cnt_idconta;
       public            postgres    false    251            :           2606    32854     complemento pk_cpl_idcomplemento 
   CONSTRAINT     i   ALTER TABLE ONLY public.complemento
    ADD CONSTRAINT pk_cpl_idcomplemento PRIMARY KEY (idcomplemento);
 J   ALTER TABLE ONLY public.complemento DROP CONSTRAINT pk_cpl_idcomplemento;
       public            postgres    false    217            `           2606    49310    exemplo pk_exemplo_idexemplo 
   CONSTRAINT     a   ALTER TABLE ONLY public.exemplo
    ADD CONSTRAINT pk_exemplo_idexemplo PRIMARY KEY (idexemplo);
 F   ALTER TABLE ONLY public.exemplo DROP CONSTRAINT pk_exemplo_idexemplo;
       public            postgres    false    228            L           2606    41058    fornecedor pk_frn_idfornecedor 
   CONSTRAINT     f   ALTER TABLE ONLY public.fornecedor
    ADD CONSTRAINT pk_frn_idfornecedor PRIMARY KEY (idfornecedor);
 H   ALTER TABLE ONLY public.fornecedor DROP CONSTRAINT pk_frn_idfornecedor;
       public            postgres    false    221            H           2606    41041    municipio pk_mnc_idmunicipio 
   CONSTRAINT     c   ALTER TABLE ONLY public.municipio
    ADD CONSTRAINT pk_mnc_idmunicipio PRIMARY KEY (idmunicipio);
 F   ALTER TABLE ONLY public.municipio DROP CONSTRAINT pk_mnc_idmunicipio;
       public            postgres    false    220            6           2606    32847 $   nacionalidade pk_ncn_idnacionalidade 
   CONSTRAINT     o   ALTER TABLE ONLY public.nacionalidade
    ADD CONSTRAINT pk_ncn_idnacionalidade PRIMARY KEY (idnacionalidade);
 N   ALTER TABLE ONLY public.nacionalidade DROP CONSTRAINT pk_ncn_idnacionalidade;
       public            postgres    false    216            \           2606    57746    pedido pk_pdd_idpedido 
   CONSTRAINT     Z   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pk_pdd_idpedido PRIMARY KEY (idpedido);
 @   ALTER TABLE ONLY public.pedido DROP CONSTRAINT pk_pdd_idpedido;
       public            postgres    false    225            ^           2606    57807 %   pedido_produto pk_pdp_idpedidoproduto 
   CONSTRAINT     t   ALTER TABLE ONLY public.pedido_produto
    ADD CONSTRAINT pk_pdp_idpedidoproduto PRIMARY KEY (idpedido, idproduto);
 O   ALTER TABLE ONLY public.pedido_produto DROP CONSTRAINT pk_pdp_idpedidoproduto;
       public            postgres    false    226    226            Y           2606    41084    produto pk_prd_idproduto 
   CONSTRAINT     ]   ALTER TABLE ONLY public.produto
    ADD CONSTRAINT pk_prd_idproduto PRIMARY KEY (idproduto);
 B   ALTER TABLE ONLY public.produto DROP CONSTRAINT pk_prd_idproduto;
       public            postgres    false    224            2           2606    32840    profissao pk_prf_idprofissao 
   CONSTRAINT     c   ALTER TABLE ONLY public.profissao
    ADD CONSTRAINT pk_prf_idprofissao PRIMARY KEY (idprofissao);
 F   ALTER TABLE ONLY public.profissao DROP CONSTRAINT pk_prf_idprofissao;
       public            postgres    false    215            T           2606    41072 &   transportadora pk_trn_idtransportadora 
   CONSTRAINT     r   ALTER TABLE ONLY public.transportadora
    ADD CONSTRAINT pk_trn_idtransportadora PRIMARY KEY (idtransportadora);
 P   ALTER TABLE ONLY public.transportadora DROP CONSTRAINT pk_trn_idtransportadora;
       public            postgres    false    223            B           2606    41032    uf pk_ufd_idunidade_federecao 
   CONSTRAINT     ]   ALTER TABLE ONLY public.uf
    ADD CONSTRAINT pk_ufd_idunidade_federecao PRIMARY KEY (iduf);
 G   ALTER TABLE ONLY public.uf DROP CONSTRAINT pk_ufd_idunidade_federecao;
       public            postgres    false    219            P           2606    41065    vendedor pk_vnd_idvendedor 
   CONSTRAINT     `   ALTER TABLE ONLY public.vendedor
    ADD CONSTRAINT pk_vnd_idvendedor PRIMARY KEY (idvendedor);
 D   ALTER TABLE ONLY public.vendedor DROP CONSTRAINT pk_vnd_idvendedor;
       public            postgres    false    222            @           2606    57675    bairro un_brr_nome 
   CONSTRAINT     M   ALTER TABLE ONLY public.bairro
    ADD CONSTRAINT un_brr_nome UNIQUE (nome);
 <   ALTER TABLE ONLY public.bairro DROP CONSTRAINT un_brr_nome;
       public            postgres    false    218            <           2606    57720    complemento un_cpl_nome 
   CONSTRAINT     R   ALTER TABLE ONLY public.complemento
    ADD CONSTRAINT un_cpl_nome UNIQUE (nome);
 A   ALTER TABLE ONLY public.complemento DROP CONSTRAINT un_cpl_nome;
       public            postgres    false    217            N           2606    57724    fornecedor un_frn_nome 
   CONSTRAINT     Q   ALTER TABLE ONLY public.fornecedor
    ADD CONSTRAINT un_frn_nome UNIQUE (nome);
 @   ALTER TABLE ONLY public.fornecedor DROP CONSTRAINT un_frn_nome;
       public            postgres    false    221            J           2606    57732    municipio un_mnc_nome 
   CONSTRAINT     P   ALTER TABLE ONLY public.municipio
    ADD CONSTRAINT un_mnc_nome UNIQUE (nome);
 ?   ALTER TABLE ONLY public.municipio DROP CONSTRAINT un_mnc_nome;
       public            postgres    false    220            8           2606    57741    nacionalidade un_ncn_nome 
   CONSTRAINT     T   ALTER TABLE ONLY public.nacionalidade
    ADD CONSTRAINT un_ncn_nome UNIQUE (nome);
 C   ALTER TABLE ONLY public.nacionalidade DROP CONSTRAINT un_ncn_nome;
       public            postgres    false    216            4           2606    57854    profissao un_prf_nome 
   CONSTRAINT     P   ALTER TABLE ONLY public.profissao
    ADD CONSTRAINT un_prf_nome UNIQUE (nome);
 ?   ALTER TABLE ONLY public.profissao DROP CONSTRAINT un_prf_nome;
       public            postgres    false    215            V           2606    57863    transportadora un_trn_nome 
   CONSTRAINT     U   ALTER TABLE ONLY public.transportadora
    ADD CONSTRAINT un_trn_nome UNIQUE (nome);
 D   ALTER TABLE ONLY public.transportadora DROP CONSTRAINT un_trn_nome;
       public            postgres    false    223            D           2606    57868    uf un_ufd_nome 
   CONSTRAINT     I   ALTER TABLE ONLY public.uf
    ADD CONSTRAINT un_ufd_nome UNIQUE (nome);
 8   ALTER TABLE ONLY public.uf DROP CONSTRAINT un_ufd_nome;
       public            postgres    false    219            F           2606    57872    uf un_ufd_sigla 
   CONSTRAINT     K   ALTER TABLE ONLY public.uf
    ADD CONSTRAINT un_ufd_sigla UNIQUE (sigla);
 9   ALTER TABLE ONLY public.uf DROP CONSTRAINT un_ufd_sigla;
       public            postgres    false    219            R           2606    57882    vendedor un_vnd_nome 
   CONSTRAINT     O   ALTER TABLE ONLY public.vendedor
    ADD CONSTRAINT un_vnd_nome UNIQUE (nome);
 >   ALTER TABLE ONLY public.vendedor DROP CONSTRAINT un_vnd_nome;
       public            postgres    false    222            .           1259    57686    idx_cln_nome    INDEX     @   CREATE INDEX idx_cln_nome ON public.cliente USING btree (nome);
     DROP INDEX public.idx_cln_nome;
       public            postgres    false    214            Z           1259    57773    idx_pdd_data_pedido    INDEX     M   CREATE INDEX idx_pdd_data_pedido ON public.pedido USING btree (data_pedido);
 '   DROP INDEX public.idx_pdd_data_pedido;
       public            postgres    false    225            W           1259    57842    idx_pdr_nome    INDEX     @   CREATE INDEX idx_pdr_nome ON public.produto USING btree (nome);
     DROP INDEX public.idx_pdr_nome;
       public            postgres    false    224            p           2620    57635    bairro log_bairro_trigger    TRIGGER     s   CREATE TRIGGER log_bairro_trigger AFTER INSERT ON public.bairro FOR EACH ROW EXECUTE FUNCTION public.bairro_log();
 2   DROP TRIGGER log_bairro_trigger ON public.bairro;
       public          postgres    false    259    218            q           2620    57640    pedido log_pedido_trigger    TRIGGER     t   CREATE TRIGGER log_pedido_trigger BEFORE DELETE ON public.pedido FOR EACH ROW EXECUTE FUNCTION public.pedido_log();
 2   DROP TRIGGER log_pedido_trigger ON public.pedido;
       public          postgres    false    260    225            c           2606    57709    cliente fk_cliente_idmunicipio    FK CONSTRAINT     �   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT fk_cliente_idmunicipio FOREIGN KEY (idmunicipio) REFERENCES public.municipio(idmunicipio);
 H   ALTER TABLE ONLY public.cliente DROP CONSTRAINT fk_cliente_idmunicipio;
       public          postgres    false    3656    220    214            d           2606    57704    cliente fk_cln_idbairro    FK CONSTRAINT     ~   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT fk_cln_idbairro FOREIGN KEY (idbairro) REFERENCES public.bairro(idbairro);
 A   ALTER TABLE ONLY public.cliente DROP CONSTRAINT fk_cln_idbairro;
       public          postgres    false    214    3646    218            e           2606    57714    cliente fk_cln_idcomplemento    FK CONSTRAINT     �   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT fk_cln_idcomplemento FOREIGN KEY (idcomplemento) REFERENCES public.complemento(idcomplemento);
 F   ALTER TABLE ONLY public.cliente DROP CONSTRAINT fk_cln_idcomplemento;
       public          postgres    false    214    217    3642            f           2606    57699    cliente fk_cln_idnacionalidade    FK CONSTRAINT     �   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT fk_cln_idnacionalidade FOREIGN KEY (idnacionalidade) REFERENCES public.nacionalidade(idnacionalidade);
 H   ALTER TABLE ONLY public.cliente DROP CONSTRAINT fk_cln_idnacionalidade;
       public          postgres    false    216    214    3638            g           2606    57694    cliente fk_cln_idprofissao    FK CONSTRAINT     �   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT fk_cln_idprofissao FOREIGN KEY (idprofissao) REFERENCES public.profissao(idprofissao);
 D   ALTER TABLE ONLY public.cliente DROP CONSTRAINT fk_cln_idprofissao;
       public          postgres    false    215    3634    214            h           2606    57735    municipio fk_mnc_iduf    FK CONSTRAINT     p   ALTER TABLE ONLY public.municipio
    ADD CONSTRAINT fk_mnc_iduf FOREIGN KEY (iduf) REFERENCES public.uf(iduf);
 ?   ALTER TABLE ONLY public.municipio DROP CONSTRAINT fk_mnc_iduf;
       public          postgres    false    219    3650    220            k           2606    57757    pedido fk_pdd_idcliente    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_pdd_idcliente FOREIGN KEY (idcliente) REFERENCES public.cliente(idcliente);
 A   ALTER TABLE ONLY public.pedido DROP CONSTRAINT fk_pdd_idcliente;
       public          postgres    false    3632    214    225            l           2606    57762    pedido fk_pdd_idtransportadora    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_pdd_idtransportadora FOREIGN KEY (idtransportadora) REFERENCES public.transportadora(idtransportadora);
 H   ALTER TABLE ONLY public.pedido DROP CONSTRAINT fk_pdd_idtransportadora;
       public          postgres    false    225    223    3668            m           2606    57767    pedido fk_pdd_idvendedor    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_pdd_idvendedor FOREIGN KEY (idvendedor) REFERENCES public.vendedor(idvendedor);
 B   ALTER TABLE ONLY public.pedido DROP CONSTRAINT fk_pdd_idvendedor;
       public          postgres    false    3664    225    222            n           2606    57797    pedido_produto fk_pdp_idpedido    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido_produto
    ADD CONSTRAINT fk_pdp_idpedido FOREIGN KEY (idpedido) REFERENCES public.pedido(idpedido);
 H   ALTER TABLE ONLY public.pedido_produto DROP CONSTRAINT fk_pdp_idpedido;
       public          postgres    false    3676    226    225            o           2606    57808    pedido_produto fk_pdp_idproduto    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido_produto
    ADD CONSTRAINT fk_pdp_idproduto FOREIGN KEY (idproduto) REFERENCES public.produto(idproduto);
 I   ALTER TABLE ONLY public.pedido_produto DROP CONSTRAINT fk_pdp_idproduto;
       public          postgres    false    224    226    3673            j           2606    57837    produto fk_prd_idfornecedor    FK CONSTRAINT     �   ALTER TABLE ONLY public.produto
    ADD CONSTRAINT fk_prd_idfornecedor FOREIGN KEY (idfornecedor) REFERENCES public.fornecedor(idfornecedor);
 E   ALTER TABLE ONLY public.produto DROP CONSTRAINT fk_prd_idfornecedor;
       public          postgres    false    3660    224    221            i           2606    57857 !   transportadora fk_trn_idmunicipio    FK CONSTRAINT     �   ALTER TABLE ONLY public.transportadora
    ADD CONSTRAINT fk_trn_idmunicipio FOREIGN KEY (idmunicipio) REFERENCES public.municipio(idmunicipio);
 K   ALTER TABLE ONLY public.transportadora DROP CONSTRAINT fk_trn_idmunicipio;
       public          postgres    false    3656    220    223               i   x�3�t�LILIU��/K�2�tN�+)��2�>�8_! 5�1�N�+IT�/N�2�I-.IU0�2����̡�����ԔҢT.K�*.C�: ��66������ �$F      "   1   x���4202�50�54S04�24�20�3�410��24�+k�O6F��� 7�            x��SKn�0]O�8��#�KǅuE��0�Ч!��W�G��됔m�H�b$ٰ8o�g����w Rpc7�*@��U��Z��m��X}�������MO����?�����~�R3A��7hРt��|1Dغ0ڱ��߷�#�W��>��qm����҉ݲ��&`cC?Eh��g9נ�%��^a}%���`�o��,�d1K�9��~���-�Jߓ;�	��پ1B��c�#��J@��Y����� 2� ����=�$��܁�I)Ca����?n.y`�#IVV(Y�����gm��-�8�`n��jGF�����b(��w/���2� �0%��ZH�JwQ����ع���<�\��*'"�a-<��^h��Ĥ&�nZ��#�Aƚ�9���l�T��?%8�סe�������/�b�CIg���(`�EK��xj�1r}Z�'��gut��z�O�����>�pq��b��W����x�=�}3��z�����c<������1�9De      
   5   x�3�tN,N�2�t,H,*I�M�+��2�I-.IU(N-,=�*/93�+F��� F�W      %   '   x�3�t��L�+IU0�00�30�2�q�C�b���� �	�         ,   x�3�t�H�-��W0�2������lc.8ۄ��6����� i��         I   x�3�tN,�Sp��-(-IL�/J-�2�ttD2�trR�=���43/��˄3$��$U�8������D�=... ��         �   x�MN;�0��S�H�Q�JLP&C-��"m/+G�ň�����F����V0�A�^��P��g;�o�Ј���j^l�D�pLqjyr
9Vp�J�ОgG�k�\|�>��Y�wN�A��-����9c�$�(4�s�K���
m<�      	   Q   x�3�t*J,��I�,J�2��,I��L�K�2���/*I�M�M-�L��p:��^�e��Z\��P�ZXzxU^rf"W� �1�         �   x�e����0�d/��h�M���_�A�Ŗ'?�w�����p���C��5� �o�O�$C��_R+�hV�p& �B����^,�.4ʰ�.m/K�~f�ѮT��l����f���FPħH>l�,�o
9ܰk�UkE�=X$�<�ɞ[u����XxnuTX����ﱼ.��pV���璭�w�5v�Pr�6U�8�L         u   x�]�[� C�q1"��^���qQl'����$򜪛j��(�&>0&8{\,��>�=�ˑhQ:xj�U���gZbY.~���Ӏ�X���]a\�>{|��0aI���ok����0W      #   F   x�34�4��FFƺ���F���z3+0�24Ǣ]���������������W� �>l         �   x�=�=
1��S�K~�n+�D,mb��f#1녬�<B.fv����038�8�(�:ƈ��XCCy!�FW�v�բ�?�>��a�� Ac(��=m5��7uio�~Č Ռ8�쌏���f�!Sm�Ͽ�M��p��q�_�/֥#�|��/          Z   x�3�t-.)MI�+I�2�t�KO��H�,��2�HM)3M8���s2�K�L9���R����8CR�KR�SK��K�L����� �J          W   x�3��t
�S)J�+.�/*I-�*MTHI,V���M,�40�2�4���<�8E]�q����T�����ë�3�r1z\\\ N�         �   x�˽	�0E���)������� $�i�
���dd�e-���#��E��%&��('X-���(g��ɴ���R.��҄��b0�+\�4�4N�~��<����zM!��S�C]kx��^Q1>(σ�� ^B+         b   x�3�t�K):��ˈ�1'��8?�˘�+�(b�阙S0��M,�L�2�.M�I��2��K����)K�K��I-.IU(N-,=�*/�:F��� �X�     