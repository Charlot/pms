package=Axlsx::Package.new
package.workbook.add_worksheet(name: 'Kanban Sheet') do |sheet|
  sheet.add_row ['Kanban','Qty']
  Kanban.all.each do |k|
    sheet.add_row [k.nr, 100], types: [:string, :string]
  end
end

package.serialize('/home/charlot/KanbanList.xlsx')
