#!/usr/bin/env ruby
#
# require aws-sdk-ruby v2

require 'aws-sdk'
require 'optparse'

SNAP_NUM = 3

params = ARGV.getopts('','cluster:', 'region:ap-northeast-1')
params.inject({}) { |hash,(k,v)| hash[k.to_sym] = v; hash }

snapshot_name = params["cluster"].to_s + Time.now.strftime("-%Y-%m-%d-%H-%M")

elasticache = Aws::ElastiCache::Client.new(region: params["region"])

# Create snapshot
begin
  resp = elasticache.create_snapshot({
    cache_cluster_id: params["cluster"].to_s,
    snapshot_name: snapshot_name,
  })
  # Check snapshot status
  begin
    desc_resp = elasticache.describe_snapshots({
      cache_cluster_id: params["cluster"].to_s,
      snapshot_name: snapshot_name,
    })
    #puts desc_resp.snapshots[0].snapshot_status
    print "."
    sleep 10
  end until ["available"].include?(desc_resp.snapshots[0].snapshot_status)
rescue => ex
  puts "Snapshot create Error."
  puts ex.message
else
  puts "Snapshot was created."
end

# Delete old snapshot
begin
  resp = elasticache.describe_snapshots({
    cache_cluster_id: params["cluster"].to_s,
  })

  old_snap = resp.snapshots.map(&:snapshot_name).sort
  snap_count = old_snap.count
  i = 0
  until snap_count <= SNAP_NUM do
    elasticache.delete_snapshot({
      snapshot_name: old_snap[i],
    })
    snap_count = snap_count -1
    i = i + 1
  end
rescue => ex
  puts "Snapshot delete error."
  puts ex.message
else
  puts "Old snapshot deleted."
end