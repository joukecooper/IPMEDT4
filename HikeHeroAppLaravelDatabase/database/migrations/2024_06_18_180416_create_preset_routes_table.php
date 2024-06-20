<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePresetRoutesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('preset_routes', function (Blueprint $table) {
            $table->id();
            $table->string('naam')->notNullable();
            $table->integer('earnable_amount_of_coin')->notNullable();
            $table->string('gpx_file_path')->notNullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('preset_routes');
    }
}
