<?php

namespace App\Http\Controllers;

use App\Models\PresetRoute;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Response;

class PresetRouteController extends Controller
{
    public function downloadGpx($id)
    {
        $route = PresetRoute::findOrFail($id);

        $filePath = storage_path('app/' . $route->gpx_file_path);

        if (!file_exists($filePath)) {
            return response()->json(['error' => 'GPX file not found.'], 404);
        }

        $fileContent = file_get_contents($filePath);

        return response($fileContent, 200)
            ->header('Content-Type', 'application/gpx+xml')
            ->header('Content-Disposition', 'attachment; filename="route-' . $id . '.gpx"');
    }

    public function getCoins($id)
    {
        $route = PresetRoute::findOrFail($id);

        return response()->json(['coins' => $route->earnable_amount_of_coin]);
    }

    public function getRoutes()
    {
        $routes = PresetRoute::select('id', 'naam as name', 'earnable_amount_of_coin as coins')->get();

        return response()->json($routes);
    }
}

