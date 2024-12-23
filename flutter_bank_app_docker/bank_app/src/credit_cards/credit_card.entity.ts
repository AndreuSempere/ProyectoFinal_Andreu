import { Accounts } from 'src/accounts/accounts.entity';
import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  JoinColumn,
  ManyToOne,
} from 'typeorm';

@Entity()
export class Credit_Card {
  @PrimaryGeneratedColumn()
  id_tarjeta: number;

  @Column({ unique: true })
  numero_tarjeta: number;

  @Column()
  tipo_tarjeta: string;

  @Column({ type: 'timestamp', nullable: true })
  fecha_expiracion: string;

  @Column()
  cvv: number;

  @Column()
  estado: string;

  @ManyToOne(
    () => Accounts,
    (accounts) => accounts.credit_card,
    {
      nullable: false,
    },
  )
  @JoinColumn({ name: 'id_cuenta' })
  accounts: Accounts;

}
