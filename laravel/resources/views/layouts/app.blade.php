
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>@yield('title') - CCTV Attendance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">

<div class="d-flex min-vh-100">
    <aside class="bg-dark text-white p-3" style="width: 250px;">
        <h4 class="mb-4">CCTV Attendance</h4>

        <a href="{{ route('dashboard') }}"
           class="d-block text-white text-decoration-none mb-3">
            Dashboard
        </a>

        <a href="{{ route('training') }}"
           class="d-block text-white text-decoration-none mb-3">
            Training Data
        </a>

        <a href="{{ route('absensi') }}"
           class="d-block text-white text-decoration-none mb-3">
            Absensi
        </a>
    </aside>

    <main class="flex-grow-1 p-4">
        @yield('content')
    </main>
</div>

</body>
</html>
