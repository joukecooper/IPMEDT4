<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('user_data', function (Blueprint $table) {

            $table->id();
            $table->string('user_seed')->unique();
            $table->string('username')->unique();
            $table->unsignedInteger('coins')->default(0);
            $table->unsignedInteger('streak_count')->default(0);
            $table->unsignedInteger('total_distance_walked')->default(0);
            $table->text('distance_walked_per_day')->nullable();
            $table->text('friends_by_id')->nullable();
            $table->timestamps();
            
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('user_data');
    }
};
