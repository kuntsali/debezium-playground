CREATE TABLE public.payload
(
    id          uuid PRIMARY KEY,
    value       varchar(4096) NULL
);

CREATE TABLE public.outbox_events
(
    id          uuid PRIMARY KEY,
    destination varchar(255) NULL,
    payload     varchar(4096) NULL,
    timestamp   TIMESTAMP(3) WITHOUT TIME ZONE NOT NULL
);
