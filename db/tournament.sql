
drop table if exists tournament_user cascade;
create table tournament_user (
    id serial primary key,
    username varchar(255) not null,
    externalref varchar(255) not null,
    externalref_type varchar(255) not null,
    password_hash varchar(255) not null,
    first_name varchar(255) not null,
    last_name varchar(255) not null,
    user_type varchar(32) CHECK ( user_type in ('admin', 'player', 'organizer') ) not null default 'player',
    mobile varchar(255),
    avatar varchar(255) default 'default_avatar.png',
    email_confirmed boolean not null default false,
    mobile_confirmed boolean not null default false,
    account_status varchar(32) CHECK ( account_status in ('pending', 'active', 'inactive', 'suspended', 'banned') ) not null default 'pending',
    created_at timestamp not null default now(),
    updated_at timestamp not null default now(),
    unique (username)
);

drop table if exists tournament_user_login cascade;
create table tournament_user_login (
    id serial primary key,
    user_id integer not null,
    login_time timestamp not null default now(),
    logout_time timestamp not null default now(),
    session_id varchar(255) not null default('*none*'),
    ip_address varchar(255),
    login_workflow varchar(32) CHECK ( login_workflow in ('email', 'sms', 'google', 'facebook') ) not null default 'email',
    login_status varchar(32) CHECK ( login_status in ('success', 'active', 'failed') ) not null default 'success',
    created_at timestamp not null default now(),
    updated_at timestamp not null default now(),
    foreign key (user_id) references tournament_user(id)
);

drop table if exists tournament cascade;
create table tournament (
    id serial primary key,
    name varchar(255) not null,
    start_date date not null,
    end_date date not null,
    location varchar(255) not null,
    description text not null,
    created_at timestamp not null default now(),
    updated_at timestamp not null default now(),
    created_by integer not null,
    foreign key (created_by) references tournament_user(id),
    updated_by integer not null,
    foreign key (updated_by) references tournament_user(id)
);

drop table if exists game cascade;
create table game (
    id serial primary key,
    name varchar(255) not null,
    description text not null,
    participants integer[] not null,
    tournament_id integer not null,
    current_state jsonb not null,
    is_started boolean not null default false,
    is_finished boolean not null default false,
    created_at timestamp not null default now(),
    updated_at timestamp not null default now()
);

drop table if exists game_event cascade;
create table game_event (
    id serial primary key,
    game_id integer not null,
    tournament_id integer not null,
    event_type varchar(255) not null,
    event_data jsonb not null,
    created_at timestamp not null default now(),
    updated_at timestamp not null default now(),
    foreign key (game_id) references game(id)
);

drop table if exists avatar cascade;
create table avatar (
    id serial primary key,
    tournament_user integer not null,
    avatar_url text not null,
    description text not null,
    created_at timestamp not null default now(),
    updated_at timestamp not null default now()
);
