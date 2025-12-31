import { drizzle } from 'drizzle-orm/postgres-js'
import postgres from 'postgres'

import * as schema from './schema.ts'

interface CloudflareEnv {
  HYPERDRIVE?: {
    connectionString: string
  }
}

export const createDbClient = (env?: CloudflareEnv) => {
  const url = env?.HYPERDRIVE?.connectionString || process.env.DATABASE_URL

  if (!url) {
    throw new Error('No database connection string found')
  }

  const client = postgres(url, {
    prepare: false,
    ssl: 'require',
  })
  return drizzle(client, { schema })
}
