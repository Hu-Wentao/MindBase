package com.mind.base.vo

data class CommonVO<T> @JvmOverloads constructor(
    val code: Int = 200,
    val msg: String = "ok",
    val data: T? = null
) {
    companion object {
        @JvmStatic
        fun success(): CommonVO<Nothing> {
            return CommonVO()
        }
    }
}