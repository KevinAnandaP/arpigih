# PRD – Pixel Action RPG Single-Player «EMBERVEIL»

**Versi:** 1.1 (Full Single-Player Expansion)  
**Tanggal:** 27 Oktober 2026  
**Status:** Approved for Pre-Production  
**Genre:** Top-Down Souls-lite Action RPG, Base-Building & Deep Crafting  
**Platform:** PC (Windows, Linux / Steam Deck) – Steam  
**Engine:** Godot 4.x (GDScript & Godot Resource Architecture)  

---

## 1. Ringkasan Eksekutif

**EMBERVEIL** adalah game *single-player action RPG* berestetika pixel art modern dengan pertarungan berbasis stamina yang taktis dan *deliberate* (setiap tebasan, roll, dan mantra menuntut komitmen), kustomisasi karakter masif (kombinasi 8 Ras × 6 Kelas = 48 Archetype), sistem reaksi 6 elemen spell, serta markas (*Stronghold*) yang bertumbuh seiring perjalanan pemain.

Game ini **murni single-player**. Tanpa beban teknis *netcode* dan *latency multiplayer*, seluruh mekanik—mulai dari responsivitas parry, kecerdasan buatan (*AI behavior*), desain arena boss, hingga pacing cerita—dioptimalkan secara presisi untuk kenyamanan dan tantangan pemain tunggal.

---

## 2. Pilar Desain & Filosofi Pengalaman

1. **Deliberate & Responsive Combat (Souls-lite):**  
   Pertarungan menuntut observasi, kesabaran, dan manajemen resource (Stamina & Mana). Tidak ada *animation cancelling* instan yang merusak komitmen aksi, namun *hitbox* dan *telegraph* pixel dirancang dengan akurasi tinggi.
2. **Kustomisasi Build Ekstrem (48 Archetype & Spell Synergy):**  
   Pemain bebas mengekspresikan gaya bermain melalui kombinasi ras, kelas, 5 slot spell aktif berantai reaksi elemen, serta alokasi skill tree yang fleksibel (dapat di-respec).
3. **Pacing Solo yang Menghargai Waktu Pemain:**  
   Fitur *full-pause* aktif di semua menu, dialog, dan inventory. Autosave checkpoint adaptif, bebas downtime akibat matchmaking atau server desync.
4. **Rumah yang Hidup (Stronghold & Dispatch):**  
   Markas bukan sekadar menu statis, melainkan safe haven yang dibangun di atas grid tile: merekrut pengrajin, memperluas kebun herba, meramu elixir, dan memajang relik ekspedisi.
5. **Teman Bertualang Taktis (Companion AI):**  
   Companion AI memberikan kedalaman narasi dan dukungan taktis dinamis melalui roda perintah (*Tactical Command Wheel*) tanpa merampas peran pemain sebagai penentu kemenangan.

---

## 3. Core Gameplay Loop

```
[Persiapan di Stronghold] 
       │  (Crafting gear, upgrade spell, atur rotasi, pilih companion)
       ▼
[Ekspedisi ke Region/Dungeon]
       │  (Eksplorasi bercabang, buka shortcut, cari secret & resource node)
       ▼
[Combat Encounter & Boss Challenge]
       │  (Manajemen stamina, reaksi elemental, tebasan/parry/dodge)
       ▼
[Looting, Checkpoint, & Material Retrieval]
       │  (Kumpulkan blueprint, bijih langka, esensi bos, resep)
       ▼
[Kepulangan Aman ke Stronghold]
       └──► (Ekspansi fasilitas, perkuat atribut, naikkan Bond companion)
```

---

## 4. Mekanik Pertarungan Terperinci

### 4.1 Aksi Dasar & Atribut Fisik

| Aksi | Biaya Stamina | I-Frame / Active Window | Recovery Frames | Penjelasan & Dampak |
| :--- | :--- | :--- | :--- | :--- |
| **Light Attack Combo (1-3)** | Rendah (12/hit) | - | 8-10 frame | Rangkaian serangan cepat untuk akumulasi status debuff. |
| **Heavy Attack (Chargeable)** | Tinggi (30-45) | - | 18-24 frame | Memberikan Poise damage masif; charge penuh memicu knockback / stagger. |
| **Dodge Roll** | Sedang (20) | Frame 3 s/d 14 (12 frame) | 8 frame | Menghindar melalui proyektil atau tebasan area musuh. |
| **Block / Guard** | Per hit (scaling) | Aktif saat tombol ditekan | Instan release | Mengurangi damage fisik 70-100% tergantung shield; drain stamina sesuai attack impact. |
| **Parry** | 0 jika sukses (25 jika gagal) | Frame 4 s/d 10 (6 frame) | 20 frame (whiff) | Membatalkan serangan musuh, mengosongkan Poise musuh, dan membuka window **Riposte / Critical Strike**. |
| **Spell Casting (1-5)** | Mana + Stamina kecil | Cast time (0.2s - 1.8s) | Bervariasi | Menembakkan proyektil elemen, buff, aura, atau hazard area. |

### 4.2 Sistem Poise, Stagger, dan Hitstop
* **Poise Meter Tersembunyi:** Setiap karakter dan musuh memiliki poise. Serangan berat, blunt weapon, dan ledakan elemen mengikis poise. Ketika habis, musuh masuk kondisi **Stagger** selama 2.5 detik.
* **Hitstop:** Setiap tebasan yang mendarat menghasilkan hitstop 2–4 frame (layar freeze mikro) untuk kepuasan visual dan audio feedback impact.

---

## 5. Sistem Archetype Masif (8 Ras × 6 Kelas = 48 Archetype)

Pemain memilih 1 Ras dan 1 Kelas saat pembuatan karakter. Setiap kombinasi memiliki **Passive Signature** unik dan membuka cabang skill tree tersendiri.

### 5.1 Matriks 8 Ras

| Ras | Trait Pasif Rasial | Bonus Atribut Dasar | Gaya Main Utama |
| :--- | :--- | :--- | :--- |
| **Ashborn (Manusia Bara)** | *Cinder Resilience:* Resistansi Fire +25%; regen HP +1.5% per detik saat HP di bawah 30%. | +Vitality, +Strength | Brawler seimbang, tahan uji. |
| **Mistwalker (Elf Kabut)** | *Aetherial Step:* Regen Mana +20%; jarak dodge roll +25% dengan i-frame bertambah 2 frame. | +Intellect, +Dexterity | Caster lincah, hit-and-run. |
| **Ironforged (Kurcaci Batu)**| *Immovable Bastion:* Armor dasar +15%; Poise tidak mudah goyah; damage block shield naik 20%. | +Strength, +Vitality | Tank kokoh, guard counter. |
| **Therian (Feral Beastfolk)** | *Primal Instinct:* Critical chance +8%; attack speed +10% selama 5 detik setelah sukses dodge. | +Dexterity, +Strength | Agresif, burst physical. |
| **Sylphid (Anak Rimba)** | *Verdant Symbiosis:* Konsumsi herba/potion memberi buff regenerasi ganda; resist Poison/Bleed. | +Spirit, +Dexterity | Ranger & Nature caster. |
| **Umbralite (Ras Bayangan)** | *Veil of Shadows:* Damage dari belakang (backstab) +35%; aggro radius musuh berkurang 20%. | +Dexterity, +Intellect | Assassin, shadow spellblade. |
| **Celestite (Keturunan Bintang)**| *Astral Attunement:* Cooldown semua spell berkurang 12%; saat casting tidak bisa diinterupsi oleh serangan ringan. | +Intellect, +Spirit | High-tier Sorcerer, Archmage. |
| **Gravebound (Penyintas Undead)**| *Death Defiance:* Kebal status Bleed; menerima fatal damage sekali per checkpoint menyisakan 1 HP dan memicu nova stun. | +Vitality, +Spirit | Death Knight, Necro-brawler. |

### 5.2 Matriks 6 Kelas

| Kelas | Peran | Senjata Utama | Mekanik Khusus |
| :--- | :--- | :--- | :--- |
| **Warden** | Melee Vanguard | Greatsword, Sword & Shield | **Shield Bash & Guard Counter:** Melepas serangan balik instan sesaat setelah sukses menahan serangan. |
| **Pyrist** | Elemental Destruction | Staves, Spell focuses | **Heat Overcharge:** Semakin sering cast elemen panas, spell damage naik hingga 40%, tapi konsumsi mana meningkat. |
| **Ranger** | Long-Range Marksman | Longbow, Crossbow, Traps | **Weakpoint Precision:** Serangan ke titik lemah musuh dari jarak jauh menjamin critical hit dan inflict Slow. |
| **Cleric** | Holy Warrior & Healer | Mace, Flail, Holy Relics | **Devotion Aura:** Menyalurkan mana menjadi medan pemulihan HP diri sendiri dan companion, serta menghukum musuh undead. |
| **Shadeblade** | Critical Assassin | Dual Daggers, Curved Blades | **Shadow Clones:** Berpindah tempat instan meninggalkan ilusi yang meledak setelah 1 detik. |
| **Spellblade** | Hybrid Melee-Magic | Rapiers, Enchanted One-Handers | **Infusion Coating:** Melapisi bilah senjata dengan elemen spell aktif terakhir selama 15 detik. |

---

## 6. Sistem Spell & Reaksi 6 Elemen

Pemain dapat memasang **5 spell aktif** secara bersamaan. Elemen saling bereaksi di tubuh musuh maupun lingkungan sekitar:

```
                  ┌───────── Fire ─────────┐
                  │                        │
               Vaporize                  Melt
                  │                        │
       Water / Frost ◄────── Shatter ────► Nature / Corrode
                  │                        │
             Superconduct              Overload
                  │                        │
                  └─────── Lightning ──────┘
                     (Holy & Void beroperasi sebagai polaritas murni)
```

### 6.1 Tabel Reaksi Elemen

| Elemen A | Elemen B | Nama Reaksi | Efek Mekanik |
| :--- | :--- | :--- | :--- |
| **Fire** | **Frost** | **Melt / Shatter** | Menghilangkan status Freeze dan menghasilkan burst damage True Damage 200%. |
| **Lightning**| **Water/Frost** | **Superconduct / Chain** | Menyengat musuh dalam radius 4 tile, menurunkan physical armor target sebesar 30% selama 6 detik. |
| **Fire** | **Nature/Poison**| **Deflagration (Ledakan)**| Gas beracun meledak menjadi bola api AOE besar yang membakar area sekitar. |
| **Lightning**| **Fire** | **Overload** | Memicu ledakan kejut yang membatalkan casting musuh dan mementalkan musuh berukuran kecil/sedang. |
| **Holy** | **Void / Dark** | **Cataclysmic Rift** | Menghisap musuh ke titik pusat gravitasi selama 2 detik lalu meledak menghancurkan shield musuh. |

---

## 7. Sistem Companion AI (Teman Perjalanan Taktis)

Karena game ini murni single-player, peran interaksi sosial dan variasi gaya bermain diperkaya melalui **4 Companion Unik**:

### 7.1 Daftar Companion

1. **Lyra of the Ashen Dawn (Pyrist / Fire Support):**
   * *Kepribadian:* Sinis, berpengetahuan luas soal reruntuhan kuno.
   * *Peran Combat:* Memberikan damage jarak jauh, menembakkan api untuk memicu reaksi elemental dari serangan dingin pemain.
2. **Kaelen the Iron-willed (Warden / Defender):**
   * *Kepribadian:* Mantan ksatria kerajaan yang memegang teguh sumpah perlindungan.
   * *Peran Combat:* Menarik aggro bos (*Taunt*), menahan proyektil dengan menara perisai, dan memberikan window parry bagi pemain.
3. **Vesper the Whisperer (Shadeblade / Rogue):**
   * *Kepribadian:* Pencuri relik misterius, gemar mengumpulkan rumor.
   * *Peran Combat:* Mengincar musuh tipe healer/mage di barisan belakang musuh, menaruh perangkap kawat berduri.
4. **Sister Evelyn (Cleric / Healer & Warder):**
   * *Kepribadian:* Tabib yang mencari penyembuhan bagi kutukan Emberveil.
   * *Peran Combat:* Mengisi HP pemain darurat, membersihkan status racun/kutukan, dan memasang kubah pelindung anti-proyektil.

### 7.2 Roda Perintah Cepat (Tactical Command Wheel - Tombol 'G')
Pemain dapat mengubah postur companion secara *real-time*:
* **Aggressive:** Fokus menyerang target yang sedang dipukul pemain untuk mempercepat combo stagger.
* **Defensive:** Menempel di dekat pemain, memprioritaskan menghentikan musuh yang mendekat.
* **Support / Synergy:** Menahan serangan pamungkas sampai pemain memicu status elemental pembuka.
* **Retreat / Hold Position:** Menghindari bahaya lingkungan (lava, perangkap duri).

### 7.3 Sistem Bond (Tingkat 1 s/d 5)
* Didapatkan dari menyelesaikan *Personal Quest*, memberikan hadiah relik ekspedisi, dan sering bertualang bersama.
* **Reward:** Membuka dialog naratif baru, perk pasif eksklusif untuk pemain, skin kosmetik, serta *Duo Synergy Attack*.

---

## 8. Sistem Stronghold (Markas yang Berkembang)

Markas adalah pulau kedamaian di tengah dunia yang hancur. Dikelola dengan sistem grid 2D:

| Fasilitas | Fungsi Gameplay | Bonus Upgrade Tier Maksimal (Tier 3) |
| :--- | :--- | :--- |
| **The Great Anvil (Forge)** | Menempa senjata, armor, dan slot permata. | Upgrade gear hingga +10; kesempatan mendapat double affix langka. |
| **Alchemical Distillery** | Meracik potion instan, elixir buff jangka panjang, dan weapon oil. | Potion membawa ekstra 2 charge; efek buff tidak hilang saat mati sekali. |
| **Arcane Conservatory** | Menggabungkan fragmen spell, merestrukturisasi modifier spell. | Membuka slot modifier ke-3 pada setiap spell aktif. |
| **Scouting Barracks** | Menugaskan companion yang sedang tidak dibawa untuk ekspedisi pasif. | Menghasilkan bijih tambang dan herba langka otomatis per 30 menit sesi bermain. |
| **Botanical Garden** | Menanam benih tanaman langka yang ditemukan di dungeon. | Memanen bahan baku elixir langka tanpa perlu grinding monster. |
| **Relic Vault** | Tempat penyimpanan tak terbatas dan lemari pameran trofi boss. | Memberikan bonus stat global pasif berdasarkan trofi boss yang dipajang. |

---

## 9. Desain Dunia & 5 Region Utama

Eksplorasi dirancang dengan struktur *semi-open interconnected* (hub and spoke) khas Souls-like: jalan pintas (ladder yang diturunkan, pintu terkunci dari satu sisi), checkpoint *Ember Hearth*, dan bahaya lingkungan dinamis.

```
                  [Stronghold: The Hearthstone]
                                │
               ┌────────────────┼────────────────┐
               ▼                ▼                ▼
       [1. Ashen Plains]  [2. Sunken Mire] [3. Whispering Crypts]
               │                │                │
               └────────────────┼────────────────┘
                                ▼
                      [4. Frostpeak Bastion]
                                │
                                ▼
                      [5. The Abyssal Core]
```

1. **Ashen Plains of Oros:** Dataran hangus berbatu, bandit perampok api, reruntuhan desa. Boss: *Forgemaster Ignis*.
2. **The Sunken Mire of Gwyll:** Rawa beracun berkabut pekat, serangga raksasa, mobilitas terhambat air lumpur. Boss: *Mother of Leaches*.
3. **Whispering Crypts of Aethel:** Labirin bawah tanah penuh teka-teki tuas, perangkap guillotine, dan ksatria kerangka bersenjata perisai menara. Boss: *The Blind Inquisitor*.
4. **Frostpeak Bastion:** Reruntuhan benteng salju di atas tebing, bahaya badai beku (drain stamina lebih cepat jika tidak dekat obor). Boss: *Vaelith the Frost Sovereign*.
5. **The Abyssal Core (Endgame):** Dimensi ketiadaan dengan gravitasi anomali, platforming presisi, dan musuh Void. Boss: *The Ashen Monarch*.

---

## 10. Arsitektur Teknis (Godot 4.x - Pure Single-Player)

### 10.1 Penghapusan Total Overhead Multiplayer
* Tidak ada RPC (*Remote Procedure Calls*), tidak ada client-side prediction, tidak ada interpolasi jitter.
* Logika game berjalan 100% lokal pada `_physics_process(delta)` dengan tick rate stabil 60 Hz.
* Memungkinkan fitur gameplay yang mustahil/rumit di multiplayer online: **Full Screen Pause, Dynamic Bullet-Time Slowdown saat weapon switch/parry riposte, dan save state instan**.

### 10.2 Struktur Node & Komposisi Entity
```
CharacterEntity (CharacterBody2D)
├── MovementComponent (Mengelola akselerasi, friksi, dodge roll)
├── HealthComponent (HP, damage mitigation, i-frame timer)
├── StaminaComponent (Stamina pool, regen delay, exhaust logic)
├── ManaComponent (Mana pool, spell cost scaling)
├── HitboxComponent (Area2D - deteksi pemberian damage ke musuh)
├── HurtboxComponent (Area2D - penerimaan damage dari luar)
├── PoiseComponent (Stagger threshold dan recovery)
├── StatusEffectReceiver (Menghitung burn, freeze, shock, poison)
├── AnimationController (Mengarahkan sprite frame sesuai state mesin)
└── StateMachine (Idle, Move, Attack, Cast, Parry, Stagger, Dead)
```

### 10.3 Manajemen Data Driven
* Semua data spell, musuh, equipment, dan dialog disimpan dalam format **Godot Custom Resource (`.tres`)**.
* Memungkinkan penambahan 150 spell dan puluhan musuh baru tanpa merekayasa ulang script GDScript.

### 10.4 Sistem Save State & Integritas File
* File save: Format JSON terkompresi dengan format versi `v1.save`.
* Dilengkapi hash checksum SHA-256 lokal untuk mendeteksi korupsi save file.
* 3 Slot penyimpanan manual + 1 Slot Autosave darurat setiap memasuki ruang bos atau beristirahat di Hearthstone.

---

## 11. Kesimpulan Pembaruan & Rencana Aksi

EMBERVEIL kini sepenuhnya diformulasikan sebagai game **Single-Player Souls-lite** yang fokus, imersif, dan padat konten:

1. **Eliminasi Co-op:** Menghemat sekitar 40-50% beban kerja pemrograman teknis (tidak ada netcode, server, lag-compensation). Waktu ini dialihkan langsung untuk memperdalam variasi 48 archetype, kecerdasan musuh, serta kepuasan rasa tebasan/parry.
2. **Kekayaan Konten:** 
   * 48 Archetype unik dari 8 Ras dan 6 Kelas.
   * 150 Spell dengan matriks reaksi elemen mandiri.
   * 4 Companion AI dengan roda perintah taktis dan sistem Bond.
   * 6 Bangunan fasilitas Stronghold dengan sistem penugasan pasif (*Scouting Barracks*).
   * 5 Region bertingkat dengan bos berfase majemuk.
3. **Penyimpanan Dokumen:** Dokumen lengkap ini telah disimpan di folder proyek Anda di `PRD.md`.

Dokumen siap menjadi acuan langsung untuk fase *Vertical Slice* dan perakitan prototipe combat pertama di Godot 4.x.