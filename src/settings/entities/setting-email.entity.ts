import { Entity, PrimaryGeneratedColumn, Column, Unique } from "typeorm";

@Entity("system_settings")
@Unique(["key"])
export class Setting {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({ type: "varchar", length: 255 })
    key: string;

    @Column({ type: "text" })
    value: string;
}
