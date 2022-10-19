package com.mind.base.functions;

import com.googlecode.aviator.runtime.function.AbstractFunction
import com.googlecode.aviator.runtime.function.FunctionUtils
import com.googlecode.aviator.runtime.type.AviatorJavaType
import com.googlecode.aviator.runtime.type.AviatorNumber
import com.googlecode.aviator.runtime.type.AviatorObject
import com.googlecode.aviator.runtime.type.AviatorString
import org.springframework.stereotype.Component

@Component("field")
class FieldFunction : AbstractFunction() {

    override fun call(env: MutableMap<String, Any>, arg1: AviatorObject): AviatorObject {
        //db record
        val query = env["record"] as Map<String,Any>
        val dbQuery = query[(arg1 as? AviatorJavaType)?.name]?:throw IllegalArgumentException("no value of arg1")
        when{
            dbQuery is Number -> return AviatorNumber.valueOf(dbQuery)
            dbQuery is String -> return AviatorString(dbQuery)
            else-> throw IllegalArgumentException("not support type ${dbQuery::class}")
        }
    }

    override fun getName(): String {
        return "field"
    }
}
