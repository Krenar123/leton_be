class BackfillPaymentsPolymorphic < ActiveRecord::Migration[8.0]
  def change
    disable_ddl_transaction

    def up
      Payment.reset_column_information
      say_with_time "Backfilling payments.payable_* from invoice_id" do
        Payment.where.not(invoice_id: nil).find_each(batch_size: 1000) do |p|
          p.update_columns(payable_type: "Invoice", payable_id: p.invoice_id)
        end
      end
      remove_column :payments, :invoice_id
      remove_index  :payments, :ref if index_exists?(:payments, :ref) # keep if you use it
    end

    def down
      add_column :payments, :invoice_id, :bigint
      # no safe down backfill
    end
  end
end
