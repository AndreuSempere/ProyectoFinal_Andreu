package com.bank.app

import android.media.AudioManager
import android.media.ToneGenerator
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.nfc.tech.IsoDep
import android.os.Bundle
import android.util.Log
import com.github.devnied.emvnfccard.parser.EmvTemplate
import com.github.devnied.emvnfccard.parser.IProvider
import com.google.gson.JsonObject
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.IOException

class MainActivity : FlutterFragmentActivity(), NfcAdapter.ReaderCallback {
    companion object {
        const val TAG = "EMVNFCApp"
        const val CHANNEL = "com.bank.app"
    }

    private var nfcAdapter: NfcAdapter? = null
    private var isScanning = false
    private var apiResult: MethodChannel.Result? = null
    private var apiCall: MethodCall? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "init" -> initNFC(result)
                "listen" -> initListen(result, call)
                "terminate" -> terminate(result)
                else -> result.notImplemented()
            }
        }
    }

    private fun terminate(res: MethodChannel.Result) {
        Log.d(TAG, "Terminating NFC listening")
        nfcAdapter?.disableReaderMode(this)
        isScanning = false
        res.success(true)
    }

    private fun initNFC(res: MethodChannel.Result) {
        Log.d(TAG, "Initializing NFC")
        nfcAdapter = NfcAdapter.getDefaultAdapter(this)
        if (nfcAdapter == null) {
            res.success(0)
            return
        }
        if (!nfcAdapter!!.isEnabled) {
            res.success(1)
            return
        }
        res.success(2)
    }

    private fun initListen(res: MethodChannel.Result, call: MethodCall) {
        if (isScanning) {
            Log.w(TAG, "Scan already in progress")
            res.success(parsedError("One read operation already running"))
            return
        }
        if (nfcAdapter == null) {
            Log.w(TAG, "NFC not ready")
            res.success(parsedError("NFC Not Yet Ready"))
            return
        }
        apiResult = res
        apiCall = call
        isScanning = true
        val options = Bundle().apply {
            putInt(NfcAdapter.EXTRA_READER_PRESENCE_CHECK_DELAY, 250)
        }
        val nfcFlags = NfcAdapter.FLAG_READER_NFC_A or NfcAdapter.FLAG_READER_NFC_B or
                NfcAdapter.FLAG_READER_NFC_F or NfcAdapter.FLAG_READER_NFC_V or
                NfcAdapter.FLAG_READER_NO_PLATFORM_SOUNDS
        nfcAdapter?.enableReaderMode(this, this, nfcFlags, options)
        Log.d(TAG, "Started NFC listening")
    }

    private fun sendCardInfo(data: String) {
        Log.d(TAG, "Sending card data: $data")
        val jsonObject = JsonObject().apply {
            addProperty("success", true)
            addProperty("cardData", data)
        }
        apiResult?.success(jsonObject.toString())
    }

    private fun parsedError(message: String): String {
        val jsonObject = JsonObject().apply {
            addProperty("success", false)
            addProperty("error", message)
        }
        return jsonObject.toString()
    }

    override fun onTagDiscovered(tag: Tag) {
        try {
            Log.d(TAG, "Tag discovered")
            val isoDep = IsoDep.get(tag)
            isoDep.connect()
            val provider: IProvider = PcscProvider(isoDep)
            val config = EmvTemplate.Config()
                .setContactLess(true)
                .setReadAllAids(true)
                .setReadTransactions(true)
                .setReadCplc(false)
                .setRemoveDefaultParsers(false)
                .setReadAt(true)

            val parser = EmvTemplate.Builder()
                .setProvider(provider)
                .setConfig(config)
                .build()

            val cardData = parser.readEmvCard().toString()
            Log.i(TAG, cardData)

            ToneGenerator(AudioManager.STREAM_MUSIC, 100).startTone(ToneGenerator.TONE_DTMF_P, 500)
            sendCardInfo(cardData)
            isScanning = false
            nfcAdapter?.disableReaderMode(this)
            isoDep.close()
        } catch (e: IOException) {
            Log.e(TAG, "Error reading card", e)
            ToneGenerator(AudioManager.STREAM_MUSIC, 100).startTone(ToneGenerator.TONE_DTMF_P, 500)
            apiResult?.success(parsedError("Issue with card read"))
            isScanning = false
            nfcAdapter?.disableReaderMode(this)
        }
    }

    override fun onPause() {
        super.onPause()
        Log.d(TAG, "Pausing activity, disabling NFC reader")
        nfcAdapter?.disableReaderMode(this)
        if (isScanning) {
            isScanning = false
        }
    }
    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "onDestroy activity, disabling NFC reader")
        nfcAdapter?.disableReaderMode(this)
        if (isScanning) {
            isScanning = false
        }
    }
    override fun onStop() {
        super.onStop()
        Log.d(TAG, "Stopping activity, disabling NFC reader")
        //nfcAdapter?.disableReaderMode(this)
        //if (isScanning) {
        //    isScanning = false
        //}
        
    }

    override fun onResume() {
        super.onResume()
        Log.d(TAG, "Resuming activity")
        if (isScanning && nfcAdapter != null) {
            val options = Bundle().apply {
                putInt(NfcAdapter.EXTRA_READER_PRESENCE_CHECK_DELAY, 250)
            }
            val nfcFlags = NfcAdapter.FLAG_READER_NFC_A or NfcAdapter.FLAG_READER_NFC_B or
                    NfcAdapter.FLAG_READER_NFC_F or NfcAdapter.FLAG_READER_NFC_V or
                    NfcAdapter.FLAG_READER_NO_PLATFORM_SOUNDS
            nfcAdapter?.enableReaderMode(this, this, nfcFlags, options)
            Log.d(TAG, "Reactivating NFC reader")
        }
    }
}
