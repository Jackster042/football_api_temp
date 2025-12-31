CREATE TABLE "leagues" (
	"id" serial PRIMARY KEY NOT NULL,
	"api_id" integer NOT NULL,
	"name" varchar(255) NOT NULL,
	"country" varchar(100),
	"logo" text,
	CONSTRAINT "leagues_api_id_unique" UNIQUE("api_id")
);
--> statement-breakpoint
CREATE TABLE "matches" (
	"id" serial PRIMARY KEY NOT NULL,
	"api_id" integer NOT NULL,
	"home_team_id" integer,
	"away_team_id" integer,
	"home_score" integer,
	"away_score" integer,
	"status" varchar(50),
	"event_date" timestamp NOT NULL,
	CONSTRAINT "matches_api_id_unique" UNIQUE("api_id")
);
--> statement-breakpoint
CREATE TABLE "teams" (
	"id" serial PRIMARY KEY NOT NULL,
	"api_id" integer NOT NULL,
	"name" varchar(255) NOT NULL,
	"league_id" integer,
	"logo" text,
	CONSTRAINT "teams_api_id_unique" UNIQUE("api_id")
);
--> statement-breakpoint
ALTER TABLE "matches" ADD CONSTRAINT "matches_home_team_id_teams_api_id_fk" FOREIGN KEY ("home_team_id") REFERENCES "public"."teams"("api_id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "matches" ADD CONSTRAINT "matches_away_team_id_teams_api_id_fk" FOREIGN KEY ("away_team_id") REFERENCES "public"."teams"("api_id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "teams" ADD CONSTRAINT "teams_league_id_leagues_api_id_fk" FOREIGN KEY ("league_id") REFERENCES "public"."leagues"("api_id") ON DELETE no action ON UPDATE no action;