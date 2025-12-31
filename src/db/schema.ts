import {
  integer,
  pgTable,
  serial,
  text,
  timestamp,
  varchar,
} from 'drizzle-orm/pg-core'

export const leagues = pgTable('leagues', {
  id: serial('id').primaryKey(),
  apiId: integer('api_id').unique().notNull(), // ID from the Football API
  name: varchar('name', { length: 255 }).notNull(),
  country: varchar('country', { length: 100 }),
  logo: text('logo'),
})

export const teams = pgTable('teams', {
  id: serial('id').primaryKey(),
  apiId: integer('api_id').unique().notNull(),
  name: varchar('name', { length: 255 }).notNull(),
  leagueId: integer('league_id').references(() => leagues.apiId),
  logo: text('logo'),
})

export const matches = pgTable('matches', {
  id: serial('id').primaryKey(),
  apiId: integer('api_id').unique().notNull(),
  homeTeamId: integer('home_team_id').references(() => teams.apiId),
  awayTeamId: integer('away_team_id').references(() => teams.apiId),
  homeScore: integer('home_score'),
  awayScore: integer('away_score'),
  status: varchar('status', { length: 50 }), // e.g., 'FT', 'LIVE', 'NS'
  eventDate: timestamp('event_date').notNull(),
})
