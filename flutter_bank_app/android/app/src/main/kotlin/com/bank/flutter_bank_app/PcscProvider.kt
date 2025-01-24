package com.example.flutter_bank_app

import android.nfc.tech.IsoDep
import com.github.devnied.emvnfccard.exception.CommunicationException
import com.github.devnied.emvnfccard.parser.IProvider
import java.io.IOException

class PcscProvider(private var mTagCom: IsoDep) : IProvider {

    @Throws(CommunicationException::class)
    override fun transceive(pCommand: ByteArray): ByteArray {
        return try {
            mTagCom.transceive(pCommand)
        } catch (e: IOException) {
            throw CommunicationException(e.message ?: "Unknown error")
        }
    }

    override fun getAt(): ByteArray {
        return mTagCom.historicalBytes // For NFC-A
    }

    fun setmTagCom(mTagCom: IsoDep) {
        this.mTagCom = mTagCom
    }
}
