local ZoneConfig = {
    TelnetConfig = {
        ip = "127.0.0.1",
        port = 8000,
    },
    HubConfig = {
        ip = "127.0.0.1",
        port = 50000,
    },
    MysqlConfig = {
        host = "127.0.0.1",
        port = 3306,
        user = "root",
        password = "",
        database = "zone_demo";
        max_packet_size = 1024 * 1024;
    },
}

return ZoneConfig
