package com.wenlincheng.pika.common.core.util;

import com.google.common.collect.Maps;
import org.apache.commons.beanutils.BeanMap;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.Iterator;
import java.util.Map;

/**
 * 工具类
 * Created by wulg on 2016/3/29 0029.
 */
public class BeanUtils
{

    /**
     * 将Bean对象转换成Map对象，将忽略掉值为null或size=0的属性
     *
     * @param obj 对象
     * @return 若给定对象为null则返回size=0的map对象
     */
    public static Map<String, Object> toMap(Object obj)
    {
        Map<String, Object> map = Maps.newHashMap();
        if (obj == null)
        {
            return map;
        }
        BeanMap beanMap = new BeanMap(obj);
        Iterator<String> it = beanMap.keyIterator();
        while (it.hasNext())
        {
            String name = it.next();
            Object value = beanMap.get(name);
            // 转换时会将类名也转换成属性，此处去掉
            if (value != null && !name.equals("class"))
            {
                map.put(name, value);
            }
        }
        return map;
    }

    /**
     * 该方法将给定的所有对象参数列表转换合并生成一个Map，对于同名属性，依次由后面替换前面的对象属性
     *
     * @param objs 对象列表
     * @return 对于值为null的对象将忽略掉
     */
    public static Map<String, Object> toMap(Object... objs)
    {
        Map<String, Object> map = Maps.newHashMap();
        for (Object object : objs)
        {
            if (object != null)
            {
                map.putAll(toMap(object));
            }
        }
        return map;
    }

    /**
     * 获取接口的泛型类型，如果不存在则返回null
     *
     * @param clazz
     * @return
     */
    public static Class<?> getGenericClass(Class<?> clazz)
    {
        Type t = clazz.getGenericSuperclass();
        if (t instanceof ParameterizedType)
        {
            Type[] p = ((ParameterizedType)t).getActualTypeArguments();
            return ((Class<?>)p[0]);
        }
        return null;
    }

//    /**
//     * 对象拷贝
//     *
//     * @param srcObj
//     * @param destObj
//     */
//    public static void copyProperties(Object srcObj, Object destObj)
//    {
//        Class<? extends Object> dest = destObj.getClass();
//        Class<? extends Object> src = srcObj.getClass();
//        Method[] ms = dest.getMethods();
//        for (int i = 0; i < ms.length; i++)
//        {
//            String name = ms[i].getName();
//            if (name.startsWith("set"))
//            {
//                Class<? extends Object>[] cc = ms[i].getParameterTypes();
//                if (cc.length == 1)
//                {
//                    String type = cc[0].getName(); // parameter type
//                    if (type.equals("java.lang.String") || type.equals("int") || type.equals("java.lang.Integer")
//                            || type.equals("long") || type.equals("java.lang.Long") || type.equals("boolean")
//                            || type.equals("java.lang.Boolean") || type.equals("java.util.Date"))
//                    {
//                        try
//                        {
//                            // get property name:
//                            String getMethod = "g" + name.substring(1);
//                            // call get method:
//                            Method getM = src.getMethod(getMethod, new Class[0]);
//                            Object ret = getM.invoke(srcObj, new Object[] {});
//                            if (ret != null)
//                            {
//                                ms[i].invoke(destObj, new Object[] {ret});
//                            }
//                        }
//                        catch (Exception e)
//                        {
//                        }
//                    }
//                }
//            }
//        }
//
//    }
}
