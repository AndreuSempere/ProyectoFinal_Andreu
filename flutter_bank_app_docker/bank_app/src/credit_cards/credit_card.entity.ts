import { Accounts } from '../accounts/accounts.entity';
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

  @Column({  type: 'bigint', unique: true })
  numero_tarjeta: number;

  @Column()
  tipo_tarjeta: string;

  @Column()
  cardHolderName: string;

  @Column({ type: 'timestamp', nullable: true })
  fecha_expiracion: string;

  @Column()
  cvv: number;

  @Column()
  color: number;

  @ManyToOne(
    () => Accounts,
    (accounts) => accounts.credit_card,
    {
      nullable: false,
      onDelete: 'CASCADE',

    },
  )
  @JoinColumn({ name: 'id_cuenta' })
  accounts: Accounts;

}
