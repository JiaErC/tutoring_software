//配置虚拟机的IP地址
// static const String vmIpAddress = '192.168.18.128';
// static const String backendPort = '8080';

//配置阿里云的IP地址
// static const String vmIpAddress = '8.140.216.239';
// static const String backendPort = '8080';

const String vmIpAddress = '127.0.0.1';
const String backendPort = '8080';

  //获取基础URL
  get baseUrl {
    return 'http://$vmIpAddress:$backendPort';
  }