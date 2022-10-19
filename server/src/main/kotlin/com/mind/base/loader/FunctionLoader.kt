package com.mind.base.loader

import com.googlecode.aviator.AviatorEvaluator
import com.googlecode.aviator.spring.SpringContextFunctionLoader
import org.springframework.context.ApplicationContext
import org.springframework.context.ApplicationContextAware
import org.springframework.stereotype.Component

@Component
class FunctionLoader : ApplicationContextAware {

    override fun setApplicationContext(applicationContext: ApplicationContext) {
        AviatorEvaluator.addFunctionLoader(SpringContextFunctionLoader(applicationContext))
    }
}