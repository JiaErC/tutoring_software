//配置虚拟机的IP地址
// static const String vmIpAddress = '192.168.18.128';
// static const String backendPort = '8080';

//阿里云服务器的IP和端口
const String vmIpAddress = '8.140.222.2';
const String backendPort = '8080';

// 本地测试用IP和端口
// const String vmIpAddress = '127.0.0.1';
// const String backendPort = '8080';

  //获取基础URL
  get baseUrl {
    return 'http://$vmIpAddress:$backendPort';
  }