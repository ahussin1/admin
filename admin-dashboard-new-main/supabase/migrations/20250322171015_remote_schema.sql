create table "public"."cart" (
    "id" uuid not null default uuid_generate_v4(),
    "user_id" uuid,
    "product_id" uuid,
    "quantity" integer not null,
    "color" text not null
);


create table "public"."coupons" (
    "code" text not null,
    "discount_type" text not null,
    "discount_value" double precision not null,
    "expiration_date" timestamp without time zone not null,
    "is_active" boolean default true,
    "new_id" uuid default uuid_generate_v4(),
    "uuid_id" uuid not null default gen_random_uuid()
);


create table "public"."inventory" (
    "id" uuid not null default uuid_generate_v4(),
    "product_id" uuid,
    "change_type" text not null,
    "quantity" integer not null,
    "reason" text,
    "created_at" timestamp with time zone default CURRENT_TIMESTAMP,
    "size" text not null default 'M'::text
);


create table "public"."order_items" (
    "id" uuid not null default uuid_generate_v4(),
    "order_id" uuid,
    "product_id" uuid,
    "quantity" integer not null,
    "color" text not null,
    "price" numeric(10,2) not null,
    "unit_price" numeric(10,2) not null default 0,
    "size" text not null default 'M'::text
);


create table "public"."orders" (
    "id" uuid not null default uuid_generate_v4(),
    "customer_id" uuid,
    "total_amount" numeric(10,2) not null,
    "status" text default 'pending'::text,
    "payment_status" text default 'pending'::text,
    "created_at" timestamp with time zone default CURRENT_TIMESTAMP
);


create table "public"."payments" (
    "id" uuid not null default uuid_generate_v4(),
    "order_id" uuid,
    "payment_method" text not null,
    "payment_status" text default 'pending'::text,
    "amount" numeric(10,2) not null,
    "payment_date" timestamp with time zone default CURRENT_TIMESTAMP,
    "stripe_payment_id" text
);


create table "public"."product_categories" (
    "id" uuid not null default uuid_generate_v4(),
    "name" text not null,
    "description" text
);


create table "public"."product_featured" (
    "id" uuid not null default gen_random_uuid(),
    "product_id" uuid not null,
    "featured_order" integer not null default 1,
    "created_at" timestamp without time zone default now()
);


create table "public"."product_images" (
    "id" uuid not null default uuid_generate_v4(),
    "product_id" uuid,
    "image_url" text not null,
    "is_main" boolean default false
);


create table "public"."products" (
    "id" uuid not null default uuid_generate_v4(),
    "name" text not null,
    "description" text,
    "price" numeric(10,2) not null,
    "colors" text[] not null,
    "image_url" text,
    "created_at" timestamp with time zone default CURRENT_TIMESTAMP,
    "category_id" uuid,
    "inventory_quantity" integer not null default 0,
    "coupon_id" uuid,
    "availableAt" timestamp without time zone default now(),
    "status" character varying(255)
);


create table "public"."profile" (
    "id" uuid not null,
    "user_id" uuid,
    "email" text not null,
    "name" text,
    "phone" text,
    "shipping_address" text,
    "created_at" timestamp without time zone default now(),
    "updated_at" timestamp without time zone default now()
);


alter table "public"."profile" enable row level security;

create table "public"."reviews" (
    "id" uuid not null default uuid_generate_v4(),
    "product_id" uuid,
    "user_id" uuid,
    "rating" integer,
    "review_text" text,
    "created_at" timestamp with time zone default CURRENT_TIMESTAMP
);


create table "public"."shipping" (
    "id" uuid not null default uuid_generate_v4(),
    "order_id" uuid,
    "shipping_address" text not null,
    "shipping_method" text not null,
    "shipping_status" text default 'pending'::text,
    "tracking_number" text,
    "created_at" timestamp with time zone default CURRENT_TIMESTAMP,
    "shipping_method_id" uuid
);


create table "public"."shipping_methods" (
    "id" uuid not null default uuid_generate_v4(),
    "name" text not null,
    "description" text,
    "price" numeric(10,2) not null
);


create table "public"."user_preferences" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid,
    "language" text default 'en'::text,
    "favorites" jsonb default '[]'::jsonb,
    "created_at" timestamp without time zone default now()
);


create table "public"."users" (
    "id" uuid not null default uuid_generate_v4(),
    "email" text not null,
    "name" text,
    "phone" text,
    "shipping_address" text,
    "created_at" timestamp with time zone default CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone default CURRENT_TIMESTAMP
);


CREATE UNIQUE INDEX cart_pkey ON public.cart USING btree (id);

CREATE UNIQUE INDEX coupons_code_key ON public.coupons USING btree (code);

CREATE UNIQUE INDEX coupons_pkey ON public.coupons USING btree (uuid_id);

CREATE UNIQUE INDEX inventory_pkey ON public.inventory USING btree (id);

CREATE UNIQUE INDEX order_items_pkey ON public.order_items USING btree (id);

CREATE UNIQUE INDEX orders_pkey ON public.orders USING btree (id);

CREATE UNIQUE INDEX payments_pkey ON public.payments USING btree (id);

CREATE UNIQUE INDEX product_categories_pkey ON public.product_categories USING btree (id);

CREATE UNIQUE INDEX product_featured_pkey ON public.product_featured USING btree (id);

CREATE UNIQUE INDEX product_images_pkey ON public.product_images USING btree (id);

CREATE UNIQUE INDEX products_pkey ON public.products USING btree (id);

CREATE UNIQUE INDEX profile_pkey ON public.profile USING btree (id);

CREATE UNIQUE INDEX reviews_pkey ON public.reviews USING btree (id);

CREATE UNIQUE INDEX shipping_methods_pkey ON public.shipping_methods USING btree (id);

CREATE UNIQUE INDEX shipping_pkey ON public.shipping USING btree (id);

CREATE UNIQUE INDEX unique_user_id ON public.user_preferences USING btree (user_id);

CREATE UNIQUE INDEX user_preferences_pkey ON public.user_preferences USING btree (id);

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);

CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);

alter table "public"."cart" add constraint "cart_pkey" PRIMARY KEY using index "cart_pkey";

alter table "public"."coupons" add constraint "coupons_pkey" PRIMARY KEY using index "coupons_pkey";

alter table "public"."inventory" add constraint "inventory_pkey" PRIMARY KEY using index "inventory_pkey";

alter table "public"."order_items" add constraint "order_items_pkey" PRIMARY KEY using index "order_items_pkey";

alter table "public"."orders" add constraint "orders_pkey" PRIMARY KEY using index "orders_pkey";

alter table "public"."payments" add constraint "payments_pkey" PRIMARY KEY using index "payments_pkey";

alter table "public"."product_categories" add constraint "product_categories_pkey" PRIMARY KEY using index "product_categories_pkey";

alter table "public"."product_featured" add constraint "product_featured_pkey" PRIMARY KEY using index "product_featured_pkey";

alter table "public"."product_images" add constraint "product_images_pkey" PRIMARY KEY using index "product_images_pkey";

alter table "public"."products" add constraint "products_pkey" PRIMARY KEY using index "products_pkey";

alter table "public"."profile" add constraint "profile_pkey" PRIMARY KEY using index "profile_pkey";

alter table "public"."reviews" add constraint "reviews_pkey" PRIMARY KEY using index "reviews_pkey";

alter table "public"."shipping" add constraint "shipping_pkey" PRIMARY KEY using index "shipping_pkey";

alter table "public"."shipping_methods" add constraint "shipping_methods_pkey" PRIMARY KEY using index "shipping_methods_pkey";

alter table "public"."user_preferences" add constraint "user_preferences_pkey" PRIMARY KEY using index "user_preferences_pkey";

alter table "public"."users" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

alter table "public"."cart" add constraint "cart_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE not valid;

alter table "public"."cart" validate constraint "cart_product_id_fkey";

alter table "public"."cart" add constraint "cart_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."cart" validate constraint "cart_user_id_fkey";

alter table "public"."coupons" add constraint "coupons_code_key" UNIQUE using index "coupons_code_key";

alter table "public"."inventory" add constraint "inventory_change_type_check" CHECK ((change_type = ANY (ARRAY['restock'::text, 'sale'::text]))) not valid;

alter table "public"."inventory" validate constraint "inventory_change_type_check";

alter table "public"."inventory" add constraint "inventory_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE not valid;

alter table "public"."inventory" validate constraint "inventory_product_id_fkey";

alter table "public"."order_items" add constraint "order_items_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE not valid;

alter table "public"."order_items" validate constraint "order_items_order_id_fkey";

alter table "public"."order_items" add constraint "order_items_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE not valid;

alter table "public"."order_items" validate constraint "order_items_product_id_fkey";

alter table "public"."orders" add constraint "orders_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."orders" validate constraint "orders_customer_id_fkey";

alter table "public"."payments" add constraint "payments_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE not valid;

alter table "public"."payments" validate constraint "payments_order_id_fkey";

alter table "public"."product_featured" add constraint "product_featured_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE not valid;

alter table "public"."product_featured" validate constraint "product_featured_product_id_fkey";

alter table "public"."product_images" add constraint "product_images_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE not valid;

alter table "public"."product_images" validate constraint "product_images_product_id_fkey";

alter table "public"."products" add constraint "products_category_id_fkey" FOREIGN KEY (category_id) REFERENCES product_categories(id) not valid;

alter table "public"."products" validate constraint "products_category_id_fkey";

alter table "public"."products" add constraint "products_coupon_id_fkey" FOREIGN KEY (coupon_id) REFERENCES coupons(uuid_id) not valid;

alter table "public"."products" validate constraint "products_coupon_id_fkey";

alter table "public"."profile" add constraint "profile_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."profile" validate constraint "profile_user_id_fkey";

alter table "public"."reviews" add constraint "reviews_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE not valid;

alter table "public"."reviews" validate constraint "reviews_product_id_fkey";

alter table "public"."reviews" add constraint "reviews_rating_check" CHECK (((rating >= 1) AND (rating <= 5))) not valid;

alter table "public"."reviews" validate constraint "reviews_rating_check";

alter table "public"."reviews" add constraint "reviews_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."reviews" validate constraint "reviews_user_id_fkey";

alter table "public"."shipping" add constraint "shipping_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE not valid;

alter table "public"."shipping" validate constraint "shipping_order_id_fkey";

alter table "public"."shipping" add constraint "shipping_shipping_method_id_fkey" FOREIGN KEY (shipping_method_id) REFERENCES shipping_methods(id) not valid;

alter table "public"."shipping" validate constraint "shipping_shipping_method_id_fkey";

alter table "public"."user_preferences" add constraint "unique_user_id" UNIQUE using index "unique_user_id";

alter table "public"."user_preferences" add constraint "user_preferences_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE not valid;

alter table "public"."user_preferences" validate constraint "user_preferences_user_id_fkey";

alter table "public"."users" add constraint "users_email_key" UNIQUE using index "users_email_key";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.sync_new_user_profile()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin
  -- Insert the new user into the profile table
  insert into public.profile (id, user_id, email, created_at)
  values (new.id, new.id, new.email, now());
  return new;
end;
$function$
;

grant delete on table "public"."cart" to "anon";

grant insert on table "public"."cart" to "anon";

grant references on table "public"."cart" to "anon";

grant select on table "public"."cart" to "anon";

grant trigger on table "public"."cart" to "anon";

grant truncate on table "public"."cart" to "anon";

grant update on table "public"."cart" to "anon";

grant delete on table "public"."cart" to "authenticated";

grant insert on table "public"."cart" to "authenticated";

grant references on table "public"."cart" to "authenticated";

grant select on table "public"."cart" to "authenticated";

grant trigger on table "public"."cart" to "authenticated";

grant truncate on table "public"."cart" to "authenticated";

grant update on table "public"."cart" to "authenticated";

grant delete on table "public"."cart" to "service_role";

grant insert on table "public"."cart" to "service_role";

grant references on table "public"."cart" to "service_role";

grant select on table "public"."cart" to "service_role";

grant trigger on table "public"."cart" to "service_role";

grant truncate on table "public"."cart" to "service_role";

grant update on table "public"."cart" to "service_role";

grant delete on table "public"."coupons" to "anon";

grant insert on table "public"."coupons" to "anon";

grant references on table "public"."coupons" to "anon";

grant select on table "public"."coupons" to "anon";

grant trigger on table "public"."coupons" to "anon";

grant truncate on table "public"."coupons" to "anon";

grant update on table "public"."coupons" to "anon";

grant delete on table "public"."coupons" to "authenticated";

grant insert on table "public"."coupons" to "authenticated";

grant references on table "public"."coupons" to "authenticated";

grant select on table "public"."coupons" to "authenticated";

grant trigger on table "public"."coupons" to "authenticated";

grant truncate on table "public"."coupons" to "authenticated";

grant update on table "public"."coupons" to "authenticated";

grant delete on table "public"."coupons" to "service_role";

grant insert on table "public"."coupons" to "service_role";

grant references on table "public"."coupons" to "service_role";

grant select on table "public"."coupons" to "service_role";

grant trigger on table "public"."coupons" to "service_role";

grant truncate on table "public"."coupons" to "service_role";

grant update on table "public"."coupons" to "service_role";

grant delete on table "public"."inventory" to "anon";

grant insert on table "public"."inventory" to "anon";

grant references on table "public"."inventory" to "anon";

grant select on table "public"."inventory" to "anon";

grant trigger on table "public"."inventory" to "anon";

grant truncate on table "public"."inventory" to "anon";

grant update on table "public"."inventory" to "anon";

grant delete on table "public"."inventory" to "authenticated";

grant insert on table "public"."inventory" to "authenticated";

grant references on table "public"."inventory" to "authenticated";

grant select on table "public"."inventory" to "authenticated";

grant trigger on table "public"."inventory" to "authenticated";

grant truncate on table "public"."inventory" to "authenticated";

grant update on table "public"."inventory" to "authenticated";

grant delete on table "public"."inventory" to "service_role";

grant insert on table "public"."inventory" to "service_role";

grant references on table "public"."inventory" to "service_role";

grant select on table "public"."inventory" to "service_role";

grant trigger on table "public"."inventory" to "service_role";

grant truncate on table "public"."inventory" to "service_role";

grant update on table "public"."inventory" to "service_role";

grant delete on table "public"."order_items" to "anon";

grant insert on table "public"."order_items" to "anon";

grant references on table "public"."order_items" to "anon";

grant select on table "public"."order_items" to "anon";

grant trigger on table "public"."order_items" to "anon";

grant truncate on table "public"."order_items" to "anon";

grant update on table "public"."order_items" to "anon";

grant delete on table "public"."order_items" to "authenticated";

grant insert on table "public"."order_items" to "authenticated";

grant references on table "public"."order_items" to "authenticated";

grant select on table "public"."order_items" to "authenticated";

grant trigger on table "public"."order_items" to "authenticated";

grant truncate on table "public"."order_items" to "authenticated";

grant update on table "public"."order_items" to "authenticated";

grant delete on table "public"."order_items" to "service_role";

grant insert on table "public"."order_items" to "service_role";

grant references on table "public"."order_items" to "service_role";

grant select on table "public"."order_items" to "service_role";

grant trigger on table "public"."order_items" to "service_role";

grant truncate on table "public"."order_items" to "service_role";

grant update on table "public"."order_items" to "service_role";

grant delete on table "public"."orders" to "anon";

grant insert on table "public"."orders" to "anon";

grant references on table "public"."orders" to "anon";

grant select on table "public"."orders" to "anon";

grant trigger on table "public"."orders" to "anon";

grant truncate on table "public"."orders" to "anon";

grant update on table "public"."orders" to "anon";

grant delete on table "public"."orders" to "authenticated";

grant insert on table "public"."orders" to "authenticated";

grant references on table "public"."orders" to "authenticated";

grant select on table "public"."orders" to "authenticated";

grant trigger on table "public"."orders" to "authenticated";

grant truncate on table "public"."orders" to "authenticated";

grant update on table "public"."orders" to "authenticated";

grant delete on table "public"."orders" to "service_role";

grant insert on table "public"."orders" to "service_role";

grant references on table "public"."orders" to "service_role";

grant select on table "public"."orders" to "service_role";

grant trigger on table "public"."orders" to "service_role";

grant truncate on table "public"."orders" to "service_role";

grant update on table "public"."orders" to "service_role";

grant delete on table "public"."payments" to "anon";

grant insert on table "public"."payments" to "anon";

grant references on table "public"."payments" to "anon";

grant select on table "public"."payments" to "anon";

grant trigger on table "public"."payments" to "anon";

grant truncate on table "public"."payments" to "anon";

grant update on table "public"."payments" to "anon";

grant delete on table "public"."payments" to "authenticated";

grant insert on table "public"."payments" to "authenticated";

grant references on table "public"."payments" to "authenticated";

grant select on table "public"."payments" to "authenticated";

grant trigger on table "public"."payments" to "authenticated";

grant truncate on table "public"."payments" to "authenticated";

grant update on table "public"."payments" to "authenticated";

grant delete on table "public"."payments" to "service_role";

grant insert on table "public"."payments" to "service_role";

grant references on table "public"."payments" to "service_role";

grant select on table "public"."payments" to "service_role";

grant trigger on table "public"."payments" to "service_role";

grant truncate on table "public"."payments" to "service_role";

grant update on table "public"."payments" to "service_role";

grant delete on table "public"."product_categories" to "anon";

grant insert on table "public"."product_categories" to "anon";

grant references on table "public"."product_categories" to "anon";

grant select on table "public"."product_categories" to "anon";

grant trigger on table "public"."product_categories" to "anon";

grant truncate on table "public"."product_categories" to "anon";

grant update on table "public"."product_categories" to "anon";

grant delete on table "public"."product_categories" to "authenticated";

grant insert on table "public"."product_categories" to "authenticated";

grant references on table "public"."product_categories" to "authenticated";

grant select on table "public"."product_categories" to "authenticated";

grant trigger on table "public"."product_categories" to "authenticated";

grant truncate on table "public"."product_categories" to "authenticated";

grant update on table "public"."product_categories" to "authenticated";

grant delete on table "public"."product_categories" to "service_role";

grant insert on table "public"."product_categories" to "service_role";

grant references on table "public"."product_categories" to "service_role";

grant select on table "public"."product_categories" to "service_role";

grant trigger on table "public"."product_categories" to "service_role";

grant truncate on table "public"."product_categories" to "service_role";

grant update on table "public"."product_categories" to "service_role";

grant delete on table "public"."product_featured" to "anon";

grant insert on table "public"."product_featured" to "anon";

grant references on table "public"."product_featured" to "anon";

grant select on table "public"."product_featured" to "anon";

grant trigger on table "public"."product_featured" to "anon";

grant truncate on table "public"."product_featured" to "anon";

grant update on table "public"."product_featured" to "anon";

grant delete on table "public"."product_featured" to "authenticated";

grant insert on table "public"."product_featured" to "authenticated";

grant references on table "public"."product_featured" to "authenticated";

grant select on table "public"."product_featured" to "authenticated";

grant trigger on table "public"."product_featured" to "authenticated";

grant truncate on table "public"."product_featured" to "authenticated";

grant update on table "public"."product_featured" to "authenticated";

grant delete on table "public"."product_featured" to "service_role";

grant insert on table "public"."product_featured" to "service_role";

grant references on table "public"."product_featured" to "service_role";

grant select on table "public"."product_featured" to "service_role";

grant trigger on table "public"."product_featured" to "service_role";

grant truncate on table "public"."product_featured" to "service_role";

grant update on table "public"."product_featured" to "service_role";

grant delete on table "public"."product_images" to "anon";

grant insert on table "public"."product_images" to "anon";

grant references on table "public"."product_images" to "anon";

grant select on table "public"."product_images" to "anon";

grant trigger on table "public"."product_images" to "anon";

grant truncate on table "public"."product_images" to "anon";

grant update on table "public"."product_images" to "anon";

grant delete on table "public"."product_images" to "authenticated";

grant insert on table "public"."product_images" to "authenticated";

grant references on table "public"."product_images" to "authenticated";

grant select on table "public"."product_images" to "authenticated";

grant trigger on table "public"."product_images" to "authenticated";

grant truncate on table "public"."product_images" to "authenticated";

grant update on table "public"."product_images" to "authenticated";

grant delete on table "public"."product_images" to "service_role";

grant insert on table "public"."product_images" to "service_role";

grant references on table "public"."product_images" to "service_role";

grant select on table "public"."product_images" to "service_role";

grant trigger on table "public"."product_images" to "service_role";

grant truncate on table "public"."product_images" to "service_role";

grant update on table "public"."product_images" to "service_role";

grant delete on table "public"."products" to "anon";

grant insert on table "public"."products" to "anon";

grant references on table "public"."products" to "anon";

grant select on table "public"."products" to "anon";

grant trigger on table "public"."products" to "anon";

grant truncate on table "public"."products" to "anon";

grant update on table "public"."products" to "anon";

grant delete on table "public"."products" to "authenticated";

grant insert on table "public"."products" to "authenticated";

grant references on table "public"."products" to "authenticated";

grant select on table "public"."products" to "authenticated";

grant trigger on table "public"."products" to "authenticated";

grant truncate on table "public"."products" to "authenticated";

grant update on table "public"."products" to "authenticated";

grant delete on table "public"."products" to "service_role";

grant insert on table "public"."products" to "service_role";

grant references on table "public"."products" to "service_role";

grant select on table "public"."products" to "service_role";

grant trigger on table "public"."products" to "service_role";

grant truncate on table "public"."products" to "service_role";

grant update on table "public"."products" to "service_role";

grant delete on table "public"."profile" to "anon";

grant insert on table "public"."profile" to "anon";

grant references on table "public"."profile" to "anon";

grant select on table "public"."profile" to "anon";

grant trigger on table "public"."profile" to "anon";

grant truncate on table "public"."profile" to "anon";

grant update on table "public"."profile" to "anon";

grant delete on table "public"."profile" to "authenticated";

grant insert on table "public"."profile" to "authenticated";

grant references on table "public"."profile" to "authenticated";

grant select on table "public"."profile" to "authenticated";

grant trigger on table "public"."profile" to "authenticated";

grant truncate on table "public"."profile" to "authenticated";

grant update on table "public"."profile" to "authenticated";

grant delete on table "public"."profile" to "service_role";

grant insert on table "public"."profile" to "service_role";

grant references on table "public"."profile" to "service_role";

grant select on table "public"."profile" to "service_role";

grant trigger on table "public"."profile" to "service_role";

grant truncate on table "public"."profile" to "service_role";

grant update on table "public"."profile" to "service_role";

grant delete on table "public"."reviews" to "anon";

grant insert on table "public"."reviews" to "anon";

grant references on table "public"."reviews" to "anon";

grant select on table "public"."reviews" to "anon";

grant trigger on table "public"."reviews" to "anon";

grant truncate on table "public"."reviews" to "anon";

grant update on table "public"."reviews" to "anon";

grant delete on table "public"."reviews" to "authenticated";

grant insert on table "public"."reviews" to "authenticated";

grant references on table "public"."reviews" to "authenticated";

grant select on table "public"."reviews" to "authenticated";

grant trigger on table "public"."reviews" to "authenticated";

grant truncate on table "public"."reviews" to "authenticated";

grant update on table "public"."reviews" to "authenticated";

grant delete on table "public"."reviews" to "service_role";

grant insert on table "public"."reviews" to "service_role";

grant references on table "public"."reviews" to "service_role";

grant select on table "public"."reviews" to "service_role";

grant trigger on table "public"."reviews" to "service_role";

grant truncate on table "public"."reviews" to "service_role";

grant update on table "public"."reviews" to "service_role";

grant delete on table "public"."shipping" to "anon";

grant insert on table "public"."shipping" to "anon";

grant references on table "public"."shipping" to "anon";

grant select on table "public"."shipping" to "anon";

grant trigger on table "public"."shipping" to "anon";

grant truncate on table "public"."shipping" to "anon";

grant update on table "public"."shipping" to "anon";

grant delete on table "public"."shipping" to "authenticated";

grant insert on table "public"."shipping" to "authenticated";

grant references on table "public"."shipping" to "authenticated";

grant select on table "public"."shipping" to "authenticated";

grant trigger on table "public"."shipping" to "authenticated";

grant truncate on table "public"."shipping" to "authenticated";

grant update on table "public"."shipping" to "authenticated";

grant delete on table "public"."shipping" to "service_role";

grant insert on table "public"."shipping" to "service_role";

grant references on table "public"."shipping" to "service_role";

grant select on table "public"."shipping" to "service_role";

grant trigger on table "public"."shipping" to "service_role";

grant truncate on table "public"."shipping" to "service_role";

grant update on table "public"."shipping" to "service_role";

grant delete on table "public"."shipping_methods" to "anon";

grant insert on table "public"."shipping_methods" to "anon";

grant references on table "public"."shipping_methods" to "anon";

grant select on table "public"."shipping_methods" to "anon";

grant trigger on table "public"."shipping_methods" to "anon";

grant truncate on table "public"."shipping_methods" to "anon";

grant update on table "public"."shipping_methods" to "anon";

grant delete on table "public"."shipping_methods" to "authenticated";

grant insert on table "public"."shipping_methods" to "authenticated";

grant references on table "public"."shipping_methods" to "authenticated";

grant select on table "public"."shipping_methods" to "authenticated";

grant trigger on table "public"."shipping_methods" to "authenticated";

grant truncate on table "public"."shipping_methods" to "authenticated";

grant update on table "public"."shipping_methods" to "authenticated";

grant delete on table "public"."shipping_methods" to "service_role";

grant insert on table "public"."shipping_methods" to "service_role";

grant references on table "public"."shipping_methods" to "service_role";

grant select on table "public"."shipping_methods" to "service_role";

grant trigger on table "public"."shipping_methods" to "service_role";

grant truncate on table "public"."shipping_methods" to "service_role";

grant update on table "public"."shipping_methods" to "service_role";

grant delete on table "public"."user_preferences" to "anon";

grant insert on table "public"."user_preferences" to "anon";

grant references on table "public"."user_preferences" to "anon";

grant select on table "public"."user_preferences" to "anon";

grant trigger on table "public"."user_preferences" to "anon";

grant truncate on table "public"."user_preferences" to "anon";

grant update on table "public"."user_preferences" to "anon";

grant delete on table "public"."user_preferences" to "authenticated";

grant insert on table "public"."user_preferences" to "authenticated";

grant references on table "public"."user_preferences" to "authenticated";

grant select on table "public"."user_preferences" to "authenticated";

grant trigger on table "public"."user_preferences" to "authenticated";

grant truncate on table "public"."user_preferences" to "authenticated";

grant update on table "public"."user_preferences" to "authenticated";

grant delete on table "public"."user_preferences" to "service_role";

grant insert on table "public"."user_preferences" to "service_role";

grant references on table "public"."user_preferences" to "service_role";

grant select on table "public"."user_preferences" to "service_role";

grant trigger on table "public"."user_preferences" to "service_role";

grant truncate on table "public"."user_preferences" to "service_role";

grant update on table "public"."user_preferences" to "service_role";

grant delete on table "public"."users" to "anon";

grant insert on table "public"."users" to "anon";

grant references on table "public"."users" to "anon";

grant select on table "public"."users" to "anon";

grant trigger on table "public"."users" to "anon";

grant truncate on table "public"."users" to "anon";

grant update on table "public"."users" to "anon";

grant delete on table "public"."users" to "authenticated";

grant insert on table "public"."users" to "authenticated";

grant references on table "public"."users" to "authenticated";

grant select on table "public"."users" to "authenticated";

grant trigger on table "public"."users" to "authenticated";

grant truncate on table "public"."users" to "authenticated";

grant update on table "public"."users" to "authenticated";

grant delete on table "public"."users" to "service_role";

grant insert on table "public"."users" to "service_role";

grant references on table "public"."users" to "service_role";

grant select on table "public"."users" to "service_role";

grant trigger on table "public"."users" to "service_role";

grant truncate on table "public"."users" to "service_role";

grant update on table "public"."users" to "service_role";

create policy "Allow logged in users to read their own profile"
on "public"."profile"
as permissive
for select
to public
using ((auth.uid() = id));



