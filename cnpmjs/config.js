module.exports = {
    debug: false,
    enableCluster: true,
    mysqlServers: [
      {
        host: '192.168.50.83',
        port: 3306,
        user: 'cnpmjs',
        password: 'cnpmjs',
      }
    ],
    mysqlDatabase: 'cnpmjs',
    enablePrivate: true,
    admins: {
      admin: 'm@glad.so',
    },
    syncModel: 'exist'// 'none', 'all', 'exist'
  };  
