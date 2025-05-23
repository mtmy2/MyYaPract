PGDMP                      |            postgres    13.16 (Debian 13.16-0+deb11u1)     16.4 (Ubuntu 16.4-1.pgdg22.04+1) #               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    13445    postgres    DATABASE     j   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';
    DROP DATABASE postgres;
                postgres    false                       0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                   postgres    false    4368                        2615    65777    auto    SCHEMA        CREATE SCHEMA auto;
    DROP SCHEMA auto;
                postgres    false            u           1259    65818    add_list    TABLE     N   CREATE TABLE auto.add_list (
    id integer NOT NULL,
    option_name text
);
    DROP TABLE auto.add_list;
       auto         heap    postgres    false    24            t           1259    65816    add_list_id_seq    SEQUENCE     �   CREATE SEQUENCE auto.add_list_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE auto.add_list_id_seq;
       auto          postgres    false    373    24                       0    0    add_list_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE auto.add_list_id_seq OWNED BY auto.add_list.id;
          auto          postgres    false    372            q           1259    65780    cars    TABLE     D   CREATE TABLE auto.cars (
    id integer NOT NULL,
    model text
);
    DROP TABLE auto.cars;
       auto         heap    postgres    false    24            p           1259    65778    cars_id_seq    SEQUENCE     �   CREATE SEQUENCE auto.cars_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
     DROP SEQUENCE auto.cars_id_seq;
       auto          postgres    false    24    369                       0    0    cars_id_seq    SEQUENCE OWNED BY     7   ALTER SEQUENCE auto.cars_id_seq OWNED BY auto.cars.id;
          auto          postgres    false    368            s           1259    65791    orders    TABLE     �   CREATE TABLE auto.orders (
    id integer NOT NULL,
    order_date date,
    manager_id integer,
    car_id integer,
    add_price numeric(9,2),
    add_set integer[]
);
    DROP TABLE auto.orders;
       auto         heap    postgres    false    24            r           1259    65789    orders_id_seq    SEQUENCE     �   CREATE SEQUENCE auto.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE auto.orders_id_seq;
       auto          postgres    false    371    24                       0    0    orders_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE auto.orders_id_seq OWNED BY auto.orders.id;
          auto          postgres    false    370            w           1259    65829    price    TABLE     Y   CREATE TABLE auto.price (
    id integer NOT NULL,
    car_id integer,
    rate jsonb
);
    DROP TABLE auto.price;
       auto         heap    postgres    false    24            v           1259    65827    price_id_seq    SEQUENCE     �   CREATE SEQUENCE auto.price_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE auto.price_id_seq;
       auto          postgres    false    24    375                       0    0    price_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE auto.price_id_seq OWNED BY auto.price.id;
          auto          postgres    false    374            n           2604    65821    add_list id    DEFAULT     f   ALTER TABLE ONLY auto.add_list ALTER COLUMN id SET DEFAULT nextval('auto.add_list_id_seq'::regclass);
 8   ALTER TABLE auto.add_list ALTER COLUMN id DROP DEFAULT;
       auto          postgres    false    372    373    373            l           2604    65783    cars id    DEFAULT     ^   ALTER TABLE ONLY auto.cars ALTER COLUMN id SET DEFAULT nextval('auto.cars_id_seq'::regclass);
 4   ALTER TABLE auto.cars ALTER COLUMN id DROP DEFAULT;
       auto          postgres    false    368    369    369            m           2604    65794 	   orders id    DEFAULT     b   ALTER TABLE ONLY auto.orders ALTER COLUMN id SET DEFAULT nextval('auto.orders_id_seq'::regclass);
 6   ALTER TABLE auto.orders ALTER COLUMN id DROP DEFAULT;
       auto          postgres    false    370    371    371            o           2604    65832    price id    DEFAULT     `   ALTER TABLE ONLY auto.price ALTER COLUMN id SET DEFAULT nextval('auto.price_id_seq'::regclass);
 5   ALTER TABLE auto.price ALTER COLUMN id DROP DEFAULT;
       auto          postgres    false    374    375    375                      0    65818    add_list 
   TABLE DATA           1   COPY auto.add_list (id, option_name) FROM stdin;
    auto          postgres    false    373   �!                 0    65780    cars 
   TABLE DATA           '   COPY auto.cars (id, model) FROM stdin;
    auto          postgres    false    369   �"                 0    65791    orders 
   TABLE DATA           V   COPY auto.orders (id, order_date, manager_id, car_id, add_price, add_set) FROM stdin;
    auto          postgres    false    371   #       
          0    65829    price 
   TABLE DATA           /   COPY auto.price (id, car_id, rate) FROM stdin;
    auto          postgres    false    375   �#                  0    0    add_list_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('auto.add_list_id_seq', 10, true);
          auto          postgres    false    372                       0    0    cars_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('auto.cars_id_seq', 8, true);
          auto          postgres    false    368                       0    0    orders_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('auto.orders_id_seq', 10, true);
          auto          postgres    false    370                       0    0    price_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('auto.price_id_seq', 8, true);
          auto          postgres    false    374            u           2606    65826    add_list add_list_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY auto.add_list
    ADD CONSTRAINT add_list_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY auto.add_list DROP CONSTRAINT add_list_pkey;
       auto            postgres    false    373            q           2606    65788    cars cars_pkey 
   CONSTRAINT     J   ALTER TABLE ONLY auto.cars
    ADD CONSTRAINT cars_pkey PRIMARY KEY (id);
 6   ALTER TABLE ONLY auto.cars DROP CONSTRAINT cars_pkey;
       auto            postgres    false    369            s           2606    65799    orders orders_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY auto.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY auto.orders DROP CONSTRAINT orders_pkey;
       auto            postgres    false    371            w           2606    65837    price price_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY auto.price
    ADD CONSTRAINT price_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY auto.price DROP CONSTRAINT price_pkey;
       auto            postgres    false    375            x           2606    65838    price price_car_id_fkey    FK CONSTRAINT     p   ALTER TABLE ONLY auto.price
    ADD CONSTRAINT price_car_id_fkey FOREIGN KEY (car_id) REFERENCES auto.cars(id);
 ?   ALTER TABLE ONLY auto.price DROP CONSTRAINT price_car_id_fkey;
       auto          postgres    false    4209    375    369               �   x�E���0D��*� ��I�?h%��NB��X��GcYZ��c�3jK-C��1�tt�k1*KР�,e�f��`o���{���ӽ�T��_¬�|=Ȃ�ܞ�F)JY/�b}ԣ���	�'	8:�/�,p�����(oW�m�,��o�}�UF��,�-I��#��V��A��         t   x��A
� ���)�����V\�ЬB��|P�U�����޻�Y+r_�}Brh�E�h!�-�ǆ^
ٵ�L�ѳ����tw�CFOM���AG�A�g��B�{k�=1�=�"�         �   x�M���0C�Pd�؎��V�Nv��B�xs֓�P01g�
]d������[ �I�B�F}�߈��uE�Z�j54���X'PY��7���m	�t>ݜ
U���'��j ��T�It���@�kAɎ�Dv��-C�Cc��!�eܫFL���"� Ο;�      
     x���A�� ��59E��h�m�a�қT�{AyVBZͦ���
+G����X��[c����W{R�Uz���"sK�i-�gAV,����\���s��G�X�HAU4UT	��Tɩ�SiWI��J�R�2T�
U��@eP�S�S�*]�B:��<U�TUw�]5�"7Uu�zRi�O*�ʦ*��0+��bw�؝+��U��;���S�|�����u�;�p	Wpd��5�b��2���mV�f�nV�U%��j�b� ��*�J�R��B%N%]u�]���mֈ     