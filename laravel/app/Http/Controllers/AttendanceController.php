<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\EncodingData;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\Process\Process;

class AttendanceController extends Controller
{
    public function dashboard()
    {
        return view('dashboard');
    }

    public function training()
    {
        $data_wajah = EncodingData::all();

        return view('training', compact('data_wajah'));
    }

    public function absensi()
    {
        $data_absensi = DB::table('absensi')
            ->join('encoding_data', 'absensi.person', '=', 'encoding_data.id')
            ->select('absensi.*', 'encoding_data.name as person')
            ->orderByDesc('absensi.id')
            ->get();

        return view('absensi', compact('data_absensi'));
    }

    public function gambar($id, $jenis){
        $data = DB::table('absensi')
            ->where('id', $id)
            ->first();

        if (!$data){
            abort(404);
        }

        if($jenis == 'masuk'){
            $gambar = $data->img_masuk;
        }elseif($jenis == 'pulang'){
            $gambar = $data->img_pulang;
        }else{abort(404);}

        return response($gambar)
            ->header('Content-Type', 'image/jpeg');
    }

    public function simpan(Request $request){
        $request->validate([
            'name' => 'required|string|max:255',
            'foto' => 'required|image|mimes:jpg,jpeg,png|max:5120'
        ]);

        $foto = $request->file('foto')->store('training');
        $lokasi_foto = Storage::path($foto);

        $project_path = dirname(base_path());
        $process = new Process([
            $project_path . '/venv/bin/python',
            $project_path . '/python/data_training.py',
            $lokasi_foto,
            $request->name
            ], base_path(),['SYSTEMROOT' => getenv('SYSTEMROOT'), 'PATH' => getenv('PATH')
        ]);

        $process->run();
        Storage::delete($foto);

        if (!$process->isSuccessful()) {
                return redirect()->route('training')
                    ->with('error', $process->getErrorOutput()
                        ?: $process->getOutput());
        }

        return redirect()->route('training')
            ->with('success', 'Data wajah berhasil disimpan!');

    }
}
