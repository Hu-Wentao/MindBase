package com.mind.base.functions

import com.googlecode.aviator.runtime.function.AbstractFunction
import com.googlecode.aviator.runtime.function.FunctionUtils
import com.googlecode.aviator.runtime.type.AviatorObject
import com.googlecode.aviator.runtime.type.AviatorString
import org.springframework.stereotype.Component

@Component("combine")
class StringCombineFunction : AbstractFunction() {

    override fun call(env: MutableMap<String, Any>?, arg1: AviatorObject?, arg2: AviatorObject?): AviatorObject {
        val strLeft = FunctionUtils.getStringValue(arg1, env)
        val strRight = FunctionUtils.getStringValue(arg2, env)
        return AviatorString(strLeft + strRight)
    }

    override fun getName(): String {
        return "combine"
    }
}