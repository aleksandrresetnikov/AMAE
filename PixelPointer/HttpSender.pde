final String matrixIP = "http://192.168.1.36:8888/";

void sendMatrix(){
  for (int x = 0;x < flagWidthHeight;x++)
    for (int y = 0;y < flagWidthHeight;y++)
      sendPixel(x, y, flags[x][y]);
}

void sendPixel(int x, int y, color c){
  getRequest("http://"+matrixIP+"/"+x+"_"+y+"_"+(int)c+"_", false);
} 

void getRequest(String url, boolean answer) {
  GetRequest get = new GetRequest(url); 
  get.send();
  if (!answer)return;
  String ret=get.getContent();
  println("URL: ", url, "returned", ret.length(), "bytes (?)");
  println("Response Content:", ret);
}
