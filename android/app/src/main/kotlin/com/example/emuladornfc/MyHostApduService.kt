package com.example.emuladornfc

import android.content.Intent
import android.net.Uri
import android.nfc.cardemulation.HostApduService
import android.os.Bundle
import android.util.Log

class MyHostApduService : HostApduService() {

    companion object {
        private const val TAG = "MyHostApduService"
        private val SELECT_APP = byteArrayOf(0x00.toByte(), 0xA4.toByte(), 0x04.toByte(), 0x00.toByte(), 0x07.toByte(), 0xD2.toByte(), 0x76.toByte(), 0x00.toByte(), 0x00.toByte(), 0x85.toByte(), 0x01.toByte(), 0x01.toByte())
        private val SELECT_NDEF_FILE = byteArrayOf(0x00.toByte(), 0xA4.toByte(), 0x00.toByte(), 0x0C.toByte(), 0x02.toByte(), 0xE1.toByte(), 0x04.toByte())
        private val SUCCESS = byteArrayOf(0x90.toByte(), 0x00.toByte())
    }

    override fun processCommandApdu(commandApdu: ByteArray?, extras: Bundle?): ByteArray {
        if (commandApdu == null) return byteArrayOf(0x6F.toByte(), 0x00.toByte())

        val hexCommand = commandApdu.joinToString("") { "%02X".format(it) }
        Log.d(TAG, "Received APDU: $hexCommand")

        return when {
            commandApdu.contentEquals(SELECT_APP) -> {
                Log.d(TAG, "SELECT APP received")
                SUCCESS
            }
            commandApdu.size >= 7 && commandApdu.sliceArray(0 until 7).contentEquals(SELECT_NDEF_FILE) -> {
                Log.d(TAG, "SELECT NDEF FILE received")
                SUCCESS
            }
            commandApdu.size >= 4 && commandApdu[0] == 0x00.toByte() && commandApdu[1] == 0xD6.toByte() -> {
                Log.d(TAG, "UPDATE BINARY received")
                processUpdateBinary(commandApdu)
                SUCCESS
            }
            else -> {
                Log.d(TAG, "Unknown command")
                byteArrayOf(0x6A.toByte(), 0x82.toByte()) // File not found
            }
        }
    }

    private fun processUpdateBinary(commandApdu: ByteArray) {
        // 00 D6 [Offset High] [Offset Low] [Length] [Data...]
        if (commandApdu.size < 5) return
        
        val data = commandApdu.sliceArray(5 until commandApdu.size)
        val url = extractUrlFromNdef(data)
        
        if (url != null) {
            Log.d(TAG, "Extracted URL: $url")
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        }
    }

    private fun extractUrlFromNdef(data: ByteArray): String? {
        // Very basic NDEF parser for URL
        // NDEF message starts with NDEF Header (1 byte), Type Length (1 byte), Payload Length (1-4 bytes), Type, Payload
        // Standard NDEF Record for URI: TNF=0x01 (Well-known), Type="U"
        
        try {
            // Find 'U' (0x55) in the record type
            var i = 0
            while (i < data.size - 1) {
                if (data[i] == 0x55.toByte()) { // URI Record Type
                    val prefixByte = data[i + 1]
                    val prefix = when (prefixByte) {
                        0x01.toByte() -> "http://www."
                        0x02.toByte() -> "https://www."
                        0x03.toByte() -> "http://"
                        0x04.toByte() -> "https://"
                        else -> ""
                    }
                    val urlPart = String(data.sliceArray(i + 2 until data.size))
                    return prefix + urlPart.filter { it.code in 32..126 } // Basic sanitization
                }
                i++
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing NDEF", e)
        }
        return null
    }

    override fun onDeactivated(reason: Int) {
        Log.d(TAG, "Deactivated reason: $reason")
    }
}
