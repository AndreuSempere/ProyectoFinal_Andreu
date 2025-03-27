import { DataSource } from 'typeorm';
import { Seeder } from 'typeorm-extension';
import creditcardData from '../../../data/credit_card';
import { Credit_Card } from '../../../credit_cards/credit_card.entity';
import { Accounts } from '../../../accounts/accounts.entity';

export class Credit_CardSeeder implements Seeder {
  public async run(dataSource: DataSource): Promise<void> {
    const creditCardRepository = dataSource.getRepository(Credit_Card);
    const accountRepository = dataSource.getRepository(Accounts);

    const accountsToSave = await Promise.all(
      creditcardData.map(async (item) => {
        const account = await accountRepository.findOne({
          where: { id_cuenta: item.id_cuenta },
        });

        if (!account) {
          throw new Error(
            `No se pudo encontrar tipo de account para el ítem: ${JSON.stringify(item)}`,
          );
        }

        return {
          id_tarjeta: item.id_tarjeta,
          numero_tarjeta: item.numero_tarjeta,
          tipo_tarjeta: item.tipo_tarjeta,
          fecha_expiracion: item.fecha_expiracion,
          cvv: item.cvv,
          estado: item.estado,
          id_cuenta: item.id_cuenta,
        };
      }),
    );
    await creditCardRepository.save(accountsToSave);

    console.log('Datos de Credit Card insertados');
  }
}
