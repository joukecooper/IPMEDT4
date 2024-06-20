<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
	DB::table('preset_routes')->insert([
            [
                'naam' => 'route-1u-4,5km',
                'earnable_amount_of_coin' => 10,
                'gpx_file_path' => 'gpx_files/route-1.gpx',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'naam' => 'route-2u-9km',
                'earnable_amount_of_coin' => 25,
                'gpx_file_path' => 'gpx_files/route-2.gpx',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'naam' => 'route-3u-13,5km',
                'earnable_amount_of_coin' => 40,
                'gpx_file_path' => 'gpx_files/route-3.gpx',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'naam' => 'route-4u-18km',
                'earnable_amount_of_coin' => 55,
                'gpx_file_path' => 'gpx_files/route-4.gpx',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}
