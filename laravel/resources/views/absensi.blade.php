@extends('layouts.app')

@section('title', 'Absensi')

@section('content')
    <h2>Data Absensi</h2>

    <div class="card shadow-sm">
        <div class="card-body">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Person</th>
                        <th>GambarMasuk</th>
                        <th>WaktuMasuk</th>
                        <th>GambarPulang</th>
                        <th>WaktuPulang</th>
                    </tr>
                </thead>

                <tbody>
                    @forelse ($data_absensi as $data)
                        <tr>
                            <td>{{ $data->id }}</td>
                            <td>{{ $data->person }}</td>
                            <td>
                                <img
                                    src="{{ route('absensi.gambar', [$data->id, 'masuk']) }}"
                                    alt="absensi masuk"
                                    width="150"
                                    class="img-thumbnail"
                                >
                            </td>
                            <td>{{ $data->absen_masuk }}</td>
                            <td>
                                @if ($data->img_pulang)
                                    <img
                                        src="{{route('absensi.gambar', [$data->id, 'pulang'])}}"
                                        alt="absensi pulang"
                                        width="150"
                                        class="img-thumbnail"
                                        >
                                @endif
                            </td>
                            <td>{{ $data->absen_pulang }}</td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="6" class="text-center">
                                Belum ada data absensi.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
@endsection