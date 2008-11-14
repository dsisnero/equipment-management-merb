Merb.logger.info("Loaded DEVELOPMENT Environment...")
Merb::Config.use { |c|
  c[:exception_details] = true
  c[:reload_templates] = true
  c[:reload_classes] = true
  c[:reload_time] = 0.5
  c[:ignore_tampered_cookies] = true
  c[:log_auto_flush ] = true
  c[:log_level] = :debug

  c[:log_stream] = STDOUT
  c[:log_file]   = nil
  # Or redirect logging into a file:
  # c[:log_file]  = Merb.root / "log" / "development.log"
}


# Merb::BootLoader.after_app_loads do
 
#   Merb::Cache.setup do
#     register(:page_store, Merb::Cache::PageStore[Merb::Cache::FileStore], :dir => Merb.root / "public")
#     register(:action_store, Merb::Cache::ActionStore[Merb::Cache::FileStore], :dir => Merb.root / "tmp")
#     #register(:memcached, Merb::Cache::MemcachedStore, :namespace => "fooful", :servers => ["127.0.0.1:11211"])
#     register(:default, Merb::Cache::AdhocStore[:page_store, :action_store])
#   end
 
# end
