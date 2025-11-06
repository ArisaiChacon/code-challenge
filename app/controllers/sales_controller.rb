class SalesController < ApplicationController
  require 'csv'

  def index
    @total_revenue = Sale.sum('item_price * item_total')
  end

  def import
    if params[:file].nil?
      redirect_to root_path, alert: "Por favor selecciona un archivo .tab"
      return
    end

    file = params[:file]

    CSV.foreach(file.path, col_sep: "\t", headers: true) do |row|
      # Buscar o crear comprador
      buyer = Buyer.find_or_create_by(name: row['comprador'])
      # Buscar o crear vendedor
      seller = Seller.find_or_create_by(
        name: row['vendedor'],
        address: row['dirección de vendedor']
      )

      # Crear venta
      Sale.create!(
        item_description: row['descripción del ítem'],
        item_price: row['precio del ítem'],
        item_total: row['total de ítems'],
        buyer: buyer,
        seller: seller
      )
    end

    redirect_to root_path, notice: "Archivo importado y datos normalizados correctamente."
  end
end