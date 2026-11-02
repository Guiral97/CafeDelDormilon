-- Pedidos de accesorios, métodos de preparación e insumos (bajo pedido a proveedores).
-- Córrelo una sola vez en Supabase → SQL Editor.
-- Cada elemento de "items" guarda: prod, cat, prov, cant, costo, margen, precio.

create table if not exists public.accesorios (
  id                uuid primary key,
  cliente           text not null default '',
  tel               text not null default '',
  fecha             date,
  notas             text not null default '',
  pagado            boolean not null default false,
  estado            text not null default 'por_pedir'
                    check (estado in ('por_pedir','pedido','recibido','entregado','anulado')),
  items             jsonb not null default '[]'::jsonb,
  creado            timestamptz not null default now(),
  ultimo_cambio_por text
);

-- Solo quien inicia sesión en la app puede leer y escribir.
alter table public.accesorios enable row level security;

drop policy if exists "equipo lee y escribe accesorios" on public.accesorios;
create policy "equipo lee y escribe accesorios" on public.accesorios
  for all to authenticated using (true) with check (true);

-- Para que los cambios aparezcan en vivo en todos los celulares.
alter publication supabase_realtime add table public.accesorios;
