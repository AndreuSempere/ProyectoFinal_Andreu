import 'reflect-metadata';
import { DataSource, DataSourceOptions } from 'typeorm';
import { runSeeders, SeederOptions } from 'typeorm-extension';
import { User } from './users/users.entity';
import { UserSeeder } from './db/seeding/seeds/users.seeder';
import { config } from 'dotenv';
import { Accounts } from './accounts/accounts.entity';
import { Account_typeSeeder } from './db/seeding/seeds/account_type.seeds';
import { AccountSeeder } from './db/seeding/seeds/accountSeed';
import { Accounts_type } from './account_type/account_type.entity';
import { Credit_Card } from './credit_cards/credit_card.entity';
import { Credit_CardSeeder } from './db/seeding/seeds/credit_card.seeds';
config();

const options: DataSourceOptions & SeederOptions = {
  type: 'mariadb',
  host: 'database',
  port: 3306,
  username: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE,

  entities: [
    User,
    Accounts,
    Accounts_type,
    Credit_Card
  ],
  seeds: [
    UserSeeder,
    Account_typeSeeder,
    AccountSeeder,
    Credit_CardSeeder,
  ],
};

const dataSource = new DataSource(options);

dataSource
  .initialize()
  .then(async () => {
    await dataSource.synchronize(true);
    await runSeeders(dataSource);
    process.exit();
  })
  .catch((error) => console.log('Error initializing data source', error));
