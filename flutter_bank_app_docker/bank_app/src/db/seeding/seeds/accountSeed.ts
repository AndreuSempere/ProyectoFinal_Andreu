import { DataSource } from 'typeorm';
import { Seeder } from 'typeorm-extension';
import accountData from '../../../data/accounts';
import { Accounts } from '../../../accounts/accounts.entity';
import { Accounts_type } from '../../../account_type/account_type.entity';
import { User } from '../../../users/users.entity';


export class AccountSeeder implements Seeder {
  public async run(dataSource: DataSource): Promise<void> {
    const accountRepository = dataSource.getRepository(Accounts);
    const accountTypeRepository = dataSource.getRepository(Accounts_type);
    const userRepository = dataSource.getRepository(User);

    const accountsToSave = await Promise.all(
      accountData.map(async (item) => {
        const accountType = await accountTypeRepository.findOne({
          where: { id_type: item.id_type },
        });
        const user = await userRepository.findOne({
          where: { id_user: item.id_usuario },
        });

        if (!accountType || !user) {
          throw new Error(
            `No se pudo encontrar tipo de account o user para el ítem: ${JSON.stringify(item)}`,
          );
        }

        return {
          numero_cuenta: item.numero_cuenta,
          saldo: item.saldo,
          moneda: item.moneda,
          estado: item.estado,
          accounts_type: accountType,
          id_user: user,
        };
      }),
    );
    await accountRepository.save(accountsToSave);

    console.log('Account seeding completed!');
  }
}
