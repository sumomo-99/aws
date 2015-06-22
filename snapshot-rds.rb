#!/usr/bin/env ruby
#
# require aws-sdk-ruby v2

require 'aws-sdk'
require 'optparse'

SNAP_NUM = 3

params = ARGV.getopts('','cluster:', 'region:ap-northeast-1')
params.inject({}) { |hash,(k,v)| hash[k.to_sym] = v; hash }

snapshot_name = params["cluster"].to_s + Time.now.strftime("-%Y-%m-%d-%H-%M")

rds = Aws::RDS::Client.new(region: params["region"])

# Create snapshot
begin
  resp = rds.create_db_snapshot({
    db_snapshot_identifier: snapshot_name,
    db_instance_identifier: params["cluster"].to_s,
  })
  # Check snapshot status
  begin
    desc_resp = rds.describe_db_snapshots({
      db_instance_identifier: params["cluster"].to_s,
      db_snapshot_identifier: snapshot_name,
    })
    #puts desc_resp.snapshots[0].snapshot_status
    print "."
    sleep 10
  end until ["available"].include?(desc_resp.db_snapshots[0].status)
rescue => ex
  puts "Snapshot create Error."
  puts ex.message
else
  puts "Snapshot was created."
end

# Delete old snapshot
begin
  resp = rds.describe_db_snapshots({
    db_instance_identifier: params["cluster"].to_s,
    snapshot_type: "manual",
  })

  old_snap = resp.db_snapshots.map(&:db_snapshot_identifier).sort
  snap_count = old_snap.count
  i = 0
  until snap_count <= SNAP_NUM do
    rds.delete_db_snapshot({
      db_snapshot_identifier: old_snap[i],
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