try-xremap-config:
  systemctl stop --user xremap.service
  RUST_LOG=debug xremap dot_config/xremap/config.yml
