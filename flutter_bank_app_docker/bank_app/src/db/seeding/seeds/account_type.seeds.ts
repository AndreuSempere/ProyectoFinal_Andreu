import { DataSource } from 'typeorm';
import { Seeder } from 'typeorm-extension';
import accountTypeData from '../../../data/account_type';
import { Accounts_type } from '../../../account_type/account_type.entity';

export class Account_typeSeeder implements Seeder {
  public async run(dataSource: DataSource): Promise<void> {
    const accountTypeRepository = dataSource.getRepository(Accounts_type);

    await accountTypeRepository.save(accountTypeData);

    console.log(
      'Datos de Accounts_type insertados',
    );
  }
}
