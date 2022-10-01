
module OpenSea
class TopCollectionsReport  < Report

  Collection =  Struct.new(:total_volume, :buf)


def build( root_dir )

  cols = []

each_dir( "#{root_dir}/*" ) do |dir|
  puts "==> #{dir}"

  meta = Meta::Collection.read( dir )

     date =  if meta.contracts.size > 0
                  meta.contracts[0].created_date
              else
                  meta.created_date
              end

  buf = String.new('')

  buf << "- **[#{meta.stats.total_supply} #{meta.name} (#{fmt_date(date)}), #{fmt_fees( meta.fees.seller_fees )}](https://opensea.io/collection/#{meta.slug})**"
  buf << "   owners: #{meta.stats.num_owners},"
  if meta.stats.total_sales > 0
    buf << "   sales:  #{meta.stats.total_sales}"
    buf << "   -  #{fmt_eth( meta.stats.total_volume )} @ "
    buf << "   price avg #{fmt_eth( meta.stats.average_price ) },"
    buf << "   floor #{fmt_eth( meta.stats.floor_price ) }"
  else
    buf << "   sales: 0"
  end
  buf << "\n"


  cols << Collection.new( meta.stats.total_volume, buf )
end
 cols = cols.sort { |l,r| r.total_volume <=> l.total_volume }


 buf = "# Top Collections by All-Time Sales Volume (in Ξ)\n\n"
 buf +=  cols.map { |col| col.buf }.join( '' )
 buf
end
end   # class TopCollectionReport
end   # module OpenSea


