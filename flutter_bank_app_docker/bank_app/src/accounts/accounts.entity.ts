import { Credit_Card } from 'src/credit_cards/credit_card.entity';
import { Accounts_type } from '../account_type/account_type.entity';
import { User } from '../users/users.entity';
import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  JoinColumn,
  ManyToOne,
  OneToMany,
} from 'typeorm';

@Entity()
export class Accounts {
  @PrimaryGeneratedColumn()
  id_cuenta: number;

  @Column()
  numero_cuenta: number;

  @Column({ unique: true })
  saldo: number;

  @Column({ default: 'EUR' })
  moneda: string;

  estado: string;

  @Column({ type: 'timestamp', nullable: true })
  fecha_creacion: Date;

  @ManyToOne(
    () => Accounts_type,
    (accounts_type) => accounts_type.accounts,
    {
      nullable: false,
    },
  )
  @JoinColumn({ name: 'id_type' })
  accounts_type: Accounts_type;

  @ManyToOne(() => User, (id_user) => id_user.accounts)
  @JoinColumn({ name: 'id_user' })
  id_user: User;

  @OneToMany(() => Credit_Card, (credit_card) => credit_card.accounts)
  credit_card: Credit_Card[];

}
